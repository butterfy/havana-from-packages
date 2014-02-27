Havana From Packages
####################

**NOTE: This guide describes installation of SINGLE NODE OPENSTACK.**

::

    git clone https://github.com/dmitry-teselkin/havana-from-packages.git
..

In general, installation steps are the same as in the official guide `OpenStack Basic Installation Guide for Ubuntu 12.04 (LTS) and Debian Wheezy <http://docs.openstack.org/grizzly/basic-install/apt/content/index.html>`_.

There are a numerous notes, however. Some of them fixes bugs and typos, and the other - correct the guide to be applicable to Havana release.

Prerequisites
=============

* Ubuntu Server 12.04.3 x64

Configure the system
====================

**Scripted**

* Configure network in **/etc/network/interfaces**

* Run the script

::

    ./configure-system.sh
..

**Manual**

* Configure network in **/etc/network/interfaces**

* Add the *ubuntu-cloud-keyring* package:

::

    ># apt-get install ubuntu-cloud-keyring
..

* Add *CloudArchive* repositories into apt sources **/etc/apt/sources.list.d/cloud-archive.list**

::

    # The primary updates archive that users should be using
    deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main

    # Public -proposed archive mimicking the SRU process for extended testing.
    # Packages should bake here for at least 7 days. 
    deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-proposed/havana main
..

* Update

::

    ># apt-get update
..

* Add to **/etc/sysctl.conf**

::

    net.ipv4.ip_forward = 1
    net.ipv4.conf.all.forwarding = 1
    net.ipv4.conf.all.rp_filter = 0
    net.ipv4.conf.default.rp_filter = 0
..

* Restart networking

::

    /etc/init.d/networking restart
..

* Apply the sysctl settings:

::

    ># sysctl -e -p /etc/sysctl.conf
..

* Install *ntp*

::

    ># apt-get install -y ntp
..

Common Services
===============

First, configure the **./openrc** file.

MySQL
-----

**Scripted**

::

    ./install-mysql.sh
..

::

    ./initialize-mysql.sh
..

**Manual**

See links below:

* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_controller.html#controller-mysql

RabbitMQ Server
---------------

**Scripted**

::

    ./install-rabbitmq-server.sh
..

**Manual**

See links below:

* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_controller.html#controller-rabbitmq

Controller Part
===============

Keystone Service
----------------

**Scripted**

::

    ./install-keystone.sh
..

::

    ./configure-keystone.sh


::

    ./initialize-keystone.sh
..

**Manual**

See links below:

* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_controller.html#basic-install_controller-keystone

Image Service
-------------

**Scripted**

::

    ./install-glance.sh
..

::

    ./configure-glance.sh
..

::

    ./initialize-glance.sh
..

**Manual**

See links below:

* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_controller.html#basic-install_controller-glance

Block Storage
-------------

**Scripted**

::

    ./install-cinder.sh
..

::

    ./configure-cinder.sh
..

**Manual**

See links below:

* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_controller.html#basic-install_controller-cinder

**Notes**

* I use virtual device for block storage service. The steps below show required actions:

::

    ># dd if=/dev/zero of=/opt/cinder-volumes.img bs=100 count=100M
    ># losetup /dev/loop0 /opt/cinder-volumes.img
..

::

    ># sfdisk /dev/loop0 << EOF
    ,,8e,,
    EOF
..

::

    ># pvcreate /dev/loop0
    ># vgcreate cinder-volumes /dev/loop0
..

Dashboard
---------

**Scripted**

::

    ./install-dashboard.sh
..

**Manual**

See links below:

* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_controller.html#basic-install_controller-dashboard

Heat
----

**Scripted**

::

    ./install-heat.sh
..

::

    ./configure-heat.sh
..

**Manual**

* Install Heat packages

::

    apt-get -y install heat-api heat-api-cfn heat-api-cloudwatch \
        heat-common heat-engine python-heat python-heatclient
..

* Configure **/etc/heat/api-paste.ini**

::

    --- api-paste.ini.orig  2013-10-08 10:07:11.672155268 -0400
    +++ api-paste.ini   2013-10-08 10:46:02.708196472 -0400
    @@ -77,6 +77,13 @@
     # Auth middleware that validates token against keystone
     [filter:authtoken]
     paste.filter_factory = heat.common.auth_token:filter_factory
    +auth_host = 127.0.0.1
    +auth_port = 35357
    +auth_protocol = http
    +auth_uri = http://127.0.0.1:5000/v2.0
    +admin_tenant_name = admin
    +admin_user = admin
    +admin_password = swordfish
     
    # Auth middleware that validates username/password against keystone
     [filter:authpassword]
..

* Configure **/etc/heat/heat.conf**

::

    --- heat.conf.orig  2013-10-08 10:08:00.071029682 -0400
    +++ heat.conf   2013-10-08 10:35:13.874480898 -0400
    @@ -137,10 +137,12 @@
     # Print debugging output (set logging level to DEBUG instead
     # of default WARNING level). (boolean value)
     #debug=false
    +debug=true
     
     # Print more verbose output (set logging level to INFO instead
     # of default WARNING level). (boolean value)
     #verbose=false
    +verbose=true
     
     # Log output to standard error (boolean value)
     #use_stderr=true
    @@ -203,6 +205,7 @@
     # (Optional) The base directory used for relative --log-file
     # paths (string value)
     #log_dir=<None>
    +log_dir=/var/log/heat
     
     # Use syslog for logging. (boolean value)
     #use_syslog=false
..

Network part
============

**Scripted**

::

    ./install-neutron.sh
..

* Configure OpenVSwitch - http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_network.html#basic-install_network-services

::

    ./configure-neutron.sh
..

**Manual**

See links below:

* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_controller.html#basic-install_controller-quantum
* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_network.html#basic-install_network-services
* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_compute.html#basic-install_compute-quantum

Compute part
============

**Scripted**

::

    ./install-compute.sh
..

::

    ./configure-compute.sh
..

**Manual**

See links below:

* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_controller.html#basic-install_controller-nova
* http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_compute.html#basic-install_compute-nova

**Notes**

::

    check the --libvirt-type if it is "kvm" then
    change it to --libvirt-type=qemu in /etc/nova/nova-compute.conf
    and reboot the machine
    your bug will get resolved
..

Links
=====

* https://wiki.ubuntu.com/ServerTeam/CloudArchive

Known Issues
============

* https://ask.openstack.org/en/question/4222/horizon-console-displays-blank-screen-with-message-novnc-ready-native-websockets-canvas-rendering/
* https://bugs.launchpad.net/horizon/+bug/1235053

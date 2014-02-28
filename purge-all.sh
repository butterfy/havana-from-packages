#!/bin/bash

# Mark OpenVSwitch packages as 'manually installed'
# To avoid accidential deleting during 'apt-get autoremove' 
apt-get --yes install \
	openvswitch-switch \
	openvswitch-common


# Purge OpenStack packages
apt-get --yes purge \
    cinder-api \
    cinder-scheduler \
    cinder-volume \
    python-cinderclient \
    nova-api \
    nova-cert \
    nova-common \
    nova-conductor \
    nova-scheduler \
    python-nova \
    python-novaclient \
    nova-consoleauth \
    novnc \
    nova-novncproxy \
    nova-compute-kvm \
    openstack-dashboard \
    memcached \
    python-memcache \
    sheepdog \
    glance \
    heat-api \
    heat-api-cfn \
    heat-api-cloudwatch \
    heat-common \
    heat-engine \
    python-heat \
    python-heatclient \
    keystone \
    python-keystone \
    python-keystoneclient \
	python-mysqldb \
	mysql-server \
    neutron-server \
    neutron-plugin-openvswitch-agent \
    neutron-dhcp-agent \
    neutron-l3-agent \
    rabbitmq-server


# Purge other packages
apt-get --yes autoremove


# Remove some folders
rm -rf /etc/cinder
rm -rf /etc/glance
rm -rf /etc/heat
rm -rf /etc/keystone
rm -rf /etc/neutron
rm -rf /etc/nova

rm -rf /var/lib/mysql


# Remove old certificates
rm /var/lib/neutron/keystone-signing/*

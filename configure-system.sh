#!/bin/bash

apt-get install --yes ubuntu-cloud-keyring

cat << EOF > /etc/apt/sources.list.d/cloud-archive.list
# The primary updates archive that users should be using
deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main

# Public -proposed archive mimicking the SRU process for extended testing.
# Packages should bake here for at least 7 days. 
deb  http://ubuntu-cloud.archive.canonical.com/ubuntu precise-proposed/havana main
EOF

#cat << EOF > /etc/apt/preferences.d/local.pref
#Package: openvswitch-*
#Pin: release o=Ubuntu
#Pin-Priority: 501
#
#Package: novnc
#Pin: release o=Ubuntu
#Pin-Priority: 501
#EOF

apt-get update


apt-get install --yes \
    python-dev \
    python-setuptools \
    htop


easy_install pip


apt-get -y install ntp


cat << EOF >> /etc/sysctl.conf


net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
EOF

/etc/init.d/networking restart

sysctl -e -p /etc/sysctl.conf

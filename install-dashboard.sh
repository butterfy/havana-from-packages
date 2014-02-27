#!/bin/bash

apt-get install --yes \
    openstack-dashboard \
    memcached \
    python-memcache

apt-get remove --yes --purge openstack-dashboard-ubuntu-theme

service apache2 restart

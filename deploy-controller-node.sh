#!/bin/bash

#set -o errexit

#source ./openrc

./configure-system.sh

./install-mysql.sh

./initialize-mysql.sh

./install-rabbitmq.sh

./install-keystone.sh

./configure-keystone.sh

./initialize-keystone.sh

./install-glance.sh

./configure-glance.sh

./initialize-glance.sh

./install-compute-on-control-node.sh

./configure-compute-on-control-node.sh

./install-cinder.sh

./configure-cinder.sh

./install-neutron-on-control-node.sh

./configure-neutron-on-control-node.sh

./install-dashboard.sh

./install-heat.sh

./configure-heat.sh

#-------------------------------------------------------------------------------

service rabbitmq-server restart
service mysql restart
service keystone restart

./restart-os-services.sh nova
./restart-os-services.sh neutron
./restart-os-services.sh cinder
./restart-os-services.sh glance

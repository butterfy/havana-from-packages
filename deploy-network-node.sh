#!/bin/bash

#set -o errexit

#source ./openrc

./configure-system.sh

./configure-system-on-network-node.sh

./install-neutron-on-network-node.sh

./configure-neutron-on-network-node.sh

#-------------------------------------------------------------------------------

./restart-os-services.sh neutron

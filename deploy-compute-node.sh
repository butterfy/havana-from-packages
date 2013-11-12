#!/bin/bash

./configure-system.sh

./install-compute-on-compute-node.sh

./configure-compute-on-compute-node.sh

./install-neutron-on-compute-node.sh

./configure-neutron-on-compute-node.sh

#-------------------------------------------------------------------------------

./restart-os-services.sh nova
./restart-os-services.sh neutron

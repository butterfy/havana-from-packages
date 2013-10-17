#!/bin/bash

#-------------------------------------------------------------------------------

cat << EOF > /etc/heat/api-paste.ini.changes
[filter:authtoken]
auth_host = $CONTROL_HOST
auth_port = 35357
auth_protocol = http
auth_uri = http://$CONTROL_HOST:5000/v2.0
admin_tenant_name = admin
admin_user = admin
admin_password = swordfish
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/heat/heat.conf.changes
[DEFAULT]
debug = True
verbose = True
log_dir = /var/log/heat
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/heat/api-paste.ini /etc/heat/api-paste.ini.changes

./merge-config.sh /etc/heat/heat.conf /etc/heat/heat.conf.changes

#-------------------------------------------------------------------------------

./restart-os-services.sh heat

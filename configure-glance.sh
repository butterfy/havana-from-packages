#!/bin/bash

source ./openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/glance/glance-api.conf.changes
[DEFAULT]
debug = True
verbose = True
sql_connection = mysql://glance:swordfish@$MYSQL_HOST/glance

[keystone_authtoken]
admin_tenant_name = service
admin_user = glance
admin_password = swordfish

[paste_deploy]
flavor = keystone
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/glance/glance-api.conf /etc/glance/glance-api.conf.changes

./merge-config.sh /etc/glance/glance-registry.conf /etc/glance/glance-api.conf.changes

./restart-os-services.sh glance

glance-manage db_sync

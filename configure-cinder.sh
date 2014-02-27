#!/bin/bash

#-------------------------------------------------------------------------------

cat << EOF > /etc/cinder/cinder.conf.changes
[DEFAULT]
sql_connection = mysql://cinder:swordfish@localhost/cinder
rabbit_password = guest
# Do not zero volumes on destroy
# This is not required on my lab, which in most cases are for testing only
volume_clear = none
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/cinder/api-paste.ini.changes
[filter:authtoken]
admin_tenant_name = service
admin_user = cinder
admin_password = swordfish
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/cinder/cinder.conf /etc/cinder/cinder.conf.changes

./merge-config.sh /etc/cinder/api-paste.ini /etc/cinder/api-paste.ini.changes


cinder-manage db sync

./restart-os-services.sh cinder

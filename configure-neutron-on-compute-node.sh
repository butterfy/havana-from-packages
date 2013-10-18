#!/bin/bash

source ./openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/neutron.conf.changes
[DEFAULT]
debug = True
verbose = True

#bind_host = 0.0.0.0
#bind_port = 9696

api_paste_config = api-paste.ini

rabbit_host = $RABBITMQ_HOST
rabbit_userid = $RABBITMQ_USERNAME
rabbit_password = $RABBITMQ_PASSWORD

#[keystone_authtoken]
#admin_tenant_name = service
#admin_user = quantum
#admin_password = swordfish

#[database]
#connection = mysql://quantum:swordfish@localhost/quantum

#[quotas]
#quota_driver = neutron.db.quota_db.DbQuotaDriver
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes
[database]
sql_connection = mysql://quantum:swordfish@$MYSQL_HOST/quantum

[ovs]
#network_vlan_ranges = physnet1
#bridge_mappings = physnet1:br-ex
tenant_network_type = gre
tunnel_id_ranges = 1:1000
enable_tunneling = True
local_ip = $HOST_IP

[agent]
tunnel_types = gre

[securitygroup]
firewall_driver = neutron.agent.firewall.NoopFirewallDriver
#firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/neutron/neutron.conf /etc/neutron/neutron.conf.changes

./merge-config.sh /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini \
    /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes

#-------------------------------------------------------------------------------

#ln -s /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini /etc/neutron/plugin.ini

./restart-os-services.sh neutron

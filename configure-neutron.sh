#!/bin/bash

source ./openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/neutron.conf.changes
[DEFAULT]
debug = True
verbose = True

bind_host = 0.0.0.0
bind_port = 9696

allow_overlapping_ips = True

api_paste_config = api-paste.ini

rabbit_host = 127.0.0.1
rabbit_userid = guest
rabbit_password = guest

[keystone_authtoken]
admin_tenant_name = service
admin_user = quantum
admin_password = swordfish

[database]
# sqlalchemy_pool_size fixes the bug below:
#    https://bugs.launchpad.net/tripleo/+bug/1184484
sqlalchemy_pool_size = 40
connection = mysql://quantum:swordfish@localhost/quantum

[quotas]
quota_driver = neutron.db.quota_db.DbQuotaDriver
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes
[database]
sql_connection = mysql://quantum:swordfish@localhost/quantum

[ovs]
network_vlan_ranges = physnet1
bridge_mappings = physnet1:br-ex
#tenant_network_type = gre
#tunnel_id_ranges = 1:1000
#enable_tunneling = True
#local_ip = 127.0.0.1

[securitygroup]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/dhcp_agent.ini.changes
[DEFAULT]
debug = True
#ovs_use_veth = True
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
use_namespaces = True
enable_isolated_metadata = True
enable_metadata_network = True
#dnsmasq_config_file = /etc/neutron/dnsmasq-neutron.conf
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/metadata_agent.ini.changes
[DEFAULT]
auth_url = http://127.0.0.1:35357/v2.0
auth_region = RegionOne
admin_tenant_name = service
admin_user = quantum
admin_password = swordfish
nova_metadata_ip = 127.0.0.1
nova_metadata_port = 8775
metadata_proxy_shared_secret = swordfish
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/dnsmasq-neutron.conf
dhcp-option-force = 26,1400
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/l3_agent.ini.changes
[DEFAULT]
debug = True
#ovs_use_veth = True
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
use_namespaces = True
external_network_bridge = br-ex
metadata_port = 9697
enable_metadata_proxy = True
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/neutron/neutron.conf /etc/neutron/neutron.conf.changes

./merge-config.sh /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini \
    /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes

./merge-config.sh /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini.changes

./merge-config.sh /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini.changes

./merge-config.sh /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini.changes

#-------------------------------------------------------------------------------

ln -s /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini /etc/neutron/plugin.ini

./restart-os-services.sh neutron

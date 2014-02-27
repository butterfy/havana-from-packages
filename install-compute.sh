#!/bin/bash

apt-get install --yes \
    nova-api \
    nova-cert \
    nova-common \
    nova-conductor \
    nova-scheduler \
    python-nova \
    python-novaclient \
    nova-consoleauth \
    novnc \
    nova-novncproxy \
    nova-compute-kvm


pip install --upgrade 'websockify<0.6.0'

#-------------------------------------------------------------------------------
#
#cat << EOF > /usr/share/novnc/include/rfb.js.patch
#--- rfb.js.orig 2013-10-10 07:17:44.578231408 -0400
#+++ rfb.js  2013-10-10 07:17:57.914152552 -0400
#@@ -1784,7 +1784,7 @@
# that.connect = function(host, port, password, path) {
#     //Util.Debug(">> connect");
# 
#-    nova_token     = token;
#+//    nova_token     = token;
#     rfb_host       = host;
#     rfb_port       = port;
#     rfb_password   = (password !== undefined)   ? password : "";
#EOF
#
#-------------------------------------------------------------------------------
#
#cd /usr/share/novnc/include/ && patch -b -p0 < rfb.js.patch

#!/bin/bash

apt-get install --yes \
    cinder-api \
    cinder-scheduler \
    cinder-volume \
    tgt \
    open-iscsi \
    python-cinderclient \
    linux-headers-$(uname -r)

#    iscsitarget \
#    iscsitarget-dkms \

#sed -i 's/false/true/g' /etc/default/iscsitarget

#service iscsitarget start
service open-iscsi start

cinder_lvm_volume='cinder-volumes'

if [[ $(lvdisplay -c | cut -d':' -f 2) = $cinder_lvm_volume ]]; then
    echo "Volume '$cinder_lvm_volume' already exists."
    exit
fi

echo ''
echo "Generating ${cinder_lvm_volume}.img file ..."
dd if=/dev/zero of=/opt/${cinder_lvm_volume}.img bs=100 count=10M
sleep 5


echo ''
echo 'Creating loop device ...'
losetup /dev/loop0 /opt/${cinder_lvm_volume}.img
sleep 5


sfdisk /dev/loop0 << EOF
,,8e,,
EOF


pvcreate /dev/loop0
vgcreate ${cinder_lvm_volume} /dev/loop0

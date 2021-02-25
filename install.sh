#!/bin/sh

# Error out if anything fails.
set -e

# Make sure script is run as root.
if [ "$(id -u)" != "0" ]; then
  echo "Must be run as root with sudo! Try: sudo ./install.sh"
  exit 1
fi

if ! grep -q "^overlay" /etc/initramfs-tools/modules; then
    echo overlay >> /etc/initramfs-tools/modules
fi

cp hooks-overlay /etc/initramfs-tools/hooks/

cp init-bottom-overlay /etc/initramfs-tools/scripts/init-bottom/

cp atomic /usr/bin

cp rootwork /usr/bin

cp show-reboot-window.sh /etc/profile.d/

cp policy /usr/share/polkit-1/actions/org.freedesktop.pkexec.policy

cat > /etc/rc.local <<EOF
#! /bin/bash
sysctl --system 
mount \`blkid -L pool\` /mnt
if [ \`cat /mnt/is_kernel_changed\` == "true" ]
then
      	sed -i 's/true/false/g' /mnt/is_kernel_changed
       	touch /tmp/is_kernel_changed
       	update-initramfs -k \`uname -r\` -u
fi
umount /mnt"
EOF


mount `blkid -L pool` /mnt
mkdir /mnt/new_kernel /mnt/old_kernel
touch /mnt/is_kernel_changed
umount /mnt

update-initramfs -k `uname -r` -u

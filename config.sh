#!/bin/bash
# config.sh - Automatic execution inside KIWI chroot
set -e

# Enable NetworkManager
systemctl enable NetworkManager.service

# Enable qemu-guest-agent
systemctl enable qemu-guest-agent.service

# Enable cloud-init
systemctl enable cloud-init-local.service
systemctl enable cloud-init.service
systemctl enable cloud-config.service
systemctl enable cloud-final.service

# Config NTP
ln -s /usr/lib/systemd/system/chronyd.service \
      /etc/systemd/system/multi-user.target.wants/chronyd.service
rm -f /etc/chrony.conf.d/pool.conf
sed -i -e 's/makestep\ 1.0\ 3/makestep\ 1.0\ -1/g' /etc/chrony.conf
for i in $(seq 1 6); do echo "server ntp$i.oneeuronet.com minpoll 4 maxpoll 6 iburst" >> /etc/chrony.conf; done

exit 0

#!/bin/bash

echo "Updating OS"

# remount root read write
/root/scripts/remount-rw.sh

# copy files
cp -f /usbdrive/Patches/Update-OS-v1.3/root/mother.pd /root
cp -f /usbdrive/Patches/Update-OS-v1.3/root/mother /root
cp /usbdrive/Patches/Update-OS-v1.3/root/.bash_profile /root
cp /usbdrive/Patches/Update-OS-v1.3/root/.jwmrc /root
cp /usbdrive/Patches/Update-OS-v1.3/root/.pdsettings /root
cp /usbdrive/Patches/Update-OS-v1.3/root/scripts/* /root/scripts

# sync
sync 

# just chill
sleep 1

# normally we'd want to remount read only, but this is not possible because of cp -f
# so we'll just shutdown instead
#/root/scripts/shutdown.sh

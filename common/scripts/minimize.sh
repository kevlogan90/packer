#!/bin/sh

sudo dd if=/dev/zero of=/EMPTY bs=1M || :
sudo rm /EMPTY

swap_device_uuid=`sudo /sbin/blkid -t TYPE=swap -o value -s UUID`
swap_device_label=`sudo /sbin/blkid -t TYPE=swap -o value -s LABEL`
if [ -n "$swap_device_uuid" ]; then
  swap_device=`readlink -f /dev/disk/by-uuid/"$swap_device_uuid"`
elif [ -n "$swap_device_label" ]; then
  swap_device=`readlink -f /dev/disk/by-label/"$swap_device_label"`
fi
sudo /sbin/swapoff "$swap_device"
sudo dd if=/dev/zero of="$swap_device" bs=1M || :
sudo /sbin/mkswap ${swap_device_label:+-L "$swap_device_label"} ${swap_device_uuid:+-U "$swap_device_uuid"} "$swap_device"
echo Finished trying to minimize the disk

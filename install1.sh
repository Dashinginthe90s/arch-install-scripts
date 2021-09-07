#!/bin/bash
source ./vars.sh

pacstrap $mountDir - < packageLists/main.txt
genfstab -U $mountDir >> $mountDir/etc/fstab
cp -r ./* $scriptDir
arch-chroot cd $scriptDir && ./install2.sh
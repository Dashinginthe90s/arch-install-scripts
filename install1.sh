#!/bin/bash
source ./vars.sh

pacstrap $mountDir - < packageLists/main.txt
genfstab -U $mountDir >> $mountDir/etc/fstab
mkdir -p $scriptDir
cp -r ./* $scriptDir
arch-chroot $scriptDir/install2.sh
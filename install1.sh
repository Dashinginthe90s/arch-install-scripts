#!/bin/bash
source ./vars.sh

pacstrap --needed $mountDir - < packageLists/main.txt
genfstab -U $mountDir >> $mountDir/etc/fstab
mkdir -p $mountDir/$scriptDir
cp -r ./* $mountDir/$scriptDir
arch-chroot $mountDir $scriptDir/install2.sh
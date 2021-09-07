#!/bin/bash
source ./vars.sh

sed "1 a scriptDir=$scriptDir" -i install2.sh

pacstrap $mountDir - < packageLists/main.txt
genfstab -U $mountDir >> $mountDir/etc/fstab
mkdir -p $mountDir/$scriptDir
cp -r ./* $mountDir/$scriptDir
arch-chroot $mountDir $scriptDir/install2.sh
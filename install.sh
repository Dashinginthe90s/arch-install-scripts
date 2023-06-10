#!/bin/bash

mountpoint /mnt || ( echo "/mnt is not mounted"; exit 1 )

extractDir=`dirname "$0"`
source "$extractDir/helpers/funcs"
source "$extractDir/helpers/vars"

sed "s;scriptDir=.*;scriptDir=$scriptDir;" -i \
"$extractDir/helpers/part2.sh"

uncomment 'ParallelDownloads' '/etc/pacman.conf'
uncomment 'VerbosePkgLists' '/etc/pacman.conf'
uncomment 'Color' '/etc/pacman.conf'

pacstrap "$mountDir" - < "$extractDir/packageLists/main.txt"
genfstab -U "$mountDir" >> "$mountDir/etc/fstab"

mkdir -p "$mountDir/$scriptDir"
cp -r \
"$extractDir/confFiles" \
"$extractDir/helpers" \
"$extractDir/homeFiles" \
"$extractDir/packageLists" \
"$extractDir/install.sh" \
"$mountDir/$scriptDir"

arch-chroot "$mountDir" "$helperDir/part2.sh"
ln -sf '/run/systemd/resolve/stub-resolv.conf' "$mountDir/etc/resolv.conf"

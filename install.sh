#!/bin/bash

extractDir=`dirname "$0"`
source "$extractDir/helpers/vars"

sed "s;scriptdir=.*;scriptDir=$scriptDir;" -i \
"$extractDir/helpers/part2.sh"

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

#!/bin/bash

scriptDir=placeholder
source "$scriptDir/helpers/vars"
source "$scriptDir/helpers/funcs"

rsync -r "$confFiles/" '/'

ln -sf "/usr/share/zoneinfo/$timezone" '/etc/localtime'
hwclock --systohc

uncomment "#$locale" '/etc/locale.gen'
locale-gen
echo "LANG=$locale" >> '/etc/locale.conf'

echo "$hostname" >> '/etc/hostname'
sed "s/hostname/$hostname/g" -i \
'/etc/hosts'

uncomment '%wheel ALL=(ALL) NOPASSWD: ALL' '/etc/sudoers'

uncomment 'ParallelDownloads' '/etc/pacman.conf'
uncomment 'VerbosePkgLists' '/etc/pacman.conf'
uncomment 'Color' '/etc/pacman.conf'

uncomment 'COMPRESSION="lz4"' '/etc/mkinitcpio.conf'
comment '^HOOKS=' '/etc/mkinitcpio.conf'
sed "/#HOOKS=/a HOOKS=($hooks)" -i '/etc/mkinitcpio.conf'
mkinitcpio -P

mkdir '/boot/grub'
grub-mkconfig -o '/boot/grub/grub.cfg'

systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable sshd
systemctl enable reflector.timer
systemctl enable fcron
systemctl enable systemd-timesyncd

useradd $username -G wheel -m
rsync -r "$homeFiles/" "/home/$username"
chown -R $username:$username "/home/$username"
chmod 700 "/home/$username/.ssh"
chmod 600 "/home/$username/.ssh/authorized_keys"

pacman -Syu --asdeps --needed --noconfirm - < \
"$packageLists/main-deps.txt"

cat "$helperDir/afterwards.txt"
bash

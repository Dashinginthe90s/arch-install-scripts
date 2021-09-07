#!/bin/bash

source $scriptDir/vars.sh
source $scriptDir/funcs.sh

rsync -r $confDir/ /

ln -sf /user/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
timedatectl set-ntp true

uncomment "#$locale" /etc/locale.gen
locale-gen
echo "LANG=$locale" >> /etc/locale.conf

echo $hostname >> /etc/hostname
sed "s/hostname/$hostname/g" -i /etc/hosts

/etc/mkinitcpio.conf /etc/mkinitcpio.bak
ln -sf /etc/mkinitcpio.conf /etc/resolv.conf
/etc/mkinitcpio.bak /etc/mkinitcpio.conf

uncomment 'ParallelDownloads' /etc/pacman.conf
uncomment 'VerbosePkgLists' /etc/pacman.conf
uncomment 'Color' /etc/pacman.conf

uncomment '%wheel ALL=(ALL) NOPASSWD: ALL' /etc/sudoers

uncomment 'COMPRESSION="lz4"' /etc/mkinitcpio.conf
comment '^HOOKS=' /etc/mkinitcpio.conf
sed '/#HOOKS=/a HOOKS=(base systemd autodetect modconf block keyboard fsck filesystems)' -i /etc/mkinitcpio.conf
mkinitcpio -P

systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable sshd
systemctl enable reflector.timer

useradd $username -G wheel -m
mkdir /home/$username/.ssh
chmod 700 /home/$username/.ssh
cp $scriptDir/authorized_keys.txt /home/$username/.ssh/authorized_keys
chmod 600 /home/$username/.ssh/authorized_keys
chown -R $username:$username /home/nicholas/.ssh

pacman -Syu --asdeps --needed --noconfirm - < $scriptDir/packageLists/main-deps.txt

cat $scriptDir/afterwards.txt
bash
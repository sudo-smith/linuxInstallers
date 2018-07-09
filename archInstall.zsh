#!/bin/zsh
#for 16gb setup

echo -e "g\nn\n1\n\n+512M\nw" 	| fdisk /dev/sda
echo -e "n\n2\n\n+10G\nw" 	| fdisk /dev/sda
echo -e "n\n3\n\n+512M\nw" 	| fdisk /dev/sda
echo -e "n\n4\n\n\n\nw" 	| fdisk /dev/sda

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
mkfs.ext4 /dev/sda4

mount /dev/sda2 /mnt

mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

mkdir /mnt/home
mount /dev/sda4 /mnt/home

pacstrap /mnt base

genfstab -U >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/America/Los_Angeles
hwclock --systohc

sed -i '/^#.* en_US.UTF-8 /s/^#//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

HOSTNAME='e440-arch'
echo $HOSTNAME > /etc/hostname
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\tlocalhost" >> /etc/hosts
echo -e "127.0.0.1\t${HOSTNAME}.localdomain\t${HOSTNAME}" >> /etc/hosts






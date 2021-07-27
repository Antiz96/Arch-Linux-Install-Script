#!/bin/bash

echo "Welcome to the Arch Linux Installer Script made by Robin Candau"
echo ""
echo "Don't forget to adapt it to your needs and preferences before using it !"
echo "All the information you need are available in the link down below"
echo "https://github.com/Antiz96/Arch-Linux-Install-Script"
echo ""
echo "/!\ WARNING /!\\"
echo "Disk partitioning is NOT currently handled by this script"
echo "Please, create your own partitions AND filesystems before using this script"
echo ""
read -n 1 -r -s -p $'Press enter to continue or ctrl + c to abort\n'
echo ""
echo ""
echo ""

#Set NTP
timedatectl set-ntp true && echo "NTP OK"

#Mount root partition
mount /dev/sda3 /mnt && echo "Mount root partition OK"

#Install Linux Kernel and base system
echo "Installating Linux Kernel and base system. This might take a few minutes..." && pacstrap /mnt base linux linux-firmware > /dev/null && echo "Linux Kernel and Base system installed"

#Generating FSTAB
genfstab -U /mnt >> /mnt/etc/fstab && echo "FSTAB generation OK"

#Set localtime
arch-chroot /mnt bash -c 'ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime && hwclock --systohc' && echo "Localtime OK"

#Set Language
arch-chroot /mnt bash -c 'sed -i "s/#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /etc/locale.gen && locale-gen > /dev/null && echo "LANG=fr_FR.UTF-8" > /etc/locale.conf && echo "KEYMAP=fr" > /etc/vconsole.conf' && echo "Language OK"

#Set Hostname
arch-chroot /mnt bash -c 'echo "Arch-Linux" > /etc/hostname && echo -e "\n127.0.0.1       localhost\n::1             localhost\n127.0.1.1       Arch-Linux.localdomain Arch-Linux" >> /etc/hosts' && echo "Hostname OK"

#Modify root password
arch-chroot /mnt bash -c 'echo "root:1234" | chpasswd' && echo "Root password modified"

#Create User
arch-chroot /mnt bash -c 'useradd -m rcandau && echo "rcandau:4321" | chpasswd && usermod -aG wheel,audio,video,optical,storage,games rcandau' && echo "User created"

#Install and configure sudo
arch-chroot /mnt bash -c 'pacman -S --noconfirm sudo > /dev/null && sed -i "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /etc/sudoers' && echo "sudo installed and configured"

#Install and configure GRUB
echo "installing and configuring GRUB. This might take a few minutes..." && arch-chroot /mnt bash -c 'pacman -S --noconfirm grub efibootmgr dosfstools mtools > /dev/null && mkdir /boot/EFI && mount /dev/sda1 /boot/EFI && grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck > /dev/null && grub-mkconfig -o /boot/grub/grub.cfg > /dev/null' && echo "GRUB installed and configured"

#Install necessary/useful packages for the base of the system + Desktop environment
echo "Installing necessary and additional packages, drivers and DE. This might take a few minutes..." && arch-chroot /mnt bash -c 'pacman -S --noconfirm networkmanager vim base-devel linux-headers intel-ucode nvidia xorg gnome > /dev/null && systemctl enable NetworkManager && systemctl enable gdm' && echo ""

#Setup keyboard layout in X11
arch-chroot /mnt bash -c 'localectl --no-convert set-x11-keymap fr' && echo "Keyboard layout configured"

#Update Grub configuration
arch-chroot /mnt bash -c 'grub-mkconfig -o /boot/grub/grub.cfg > /dev/null' && echo "Grub configuration updated"

#Exit chroot and umount root partition
arch-chroot /mnt bash -c 'exit' && umount -l /mnt && echo "Umount root partition OK"

echo ""
echo ""
echo ""
echo "Installation complete"
echo ""
echo ""
echo ""
echo "The computer will reboot automatically in a few second"
echo "Don't forget to unplug your USB key or ISO support"
sleep 10 && reboot

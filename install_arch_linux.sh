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
timedatectl set-ntp true && echo "NTP OK" || exit 1

#Mount root partition
mount /dev/sda3 /mnt && echo "Mount root partition OK" || exit 1

#Install Linux Kernel and base system
echo "Installating Linux Kernel and base system. This might take a few minutes..." && pacstrap /mnt base linux linux-firmware > /dev/null && echo "Linux Kernel and Base system installed" || exit 1

#Generating FSTAB
genfstab -U /mnt >> /mnt/etc/fstab && echo "FSTAB generation OK" || exit 1

#Set localtime
arch-chroot /mnt bash -c 'ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime && hwclock --systohc' && echo "Localtime OK" || exit 1

#Set Language
arch-chroot /mnt bash -c 'sed -i "s/#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /etc/locale.gen && locale-gen > /dev/null && echo "LANG=fr_FR.UTF-8" > /etc/locale.conf && echo "KEYMAP=fr" > /etc/vconsole.conf' && echo "Language OK" || exit 1

#Set Hostname
arch-chroot /mnt bash -c 'echo "Arch-Linux" > /etc/hostname && echo -e "\n127.0.0.1       localhost\n::1             localhost\n127.0.1.1       Arch-Linux.localdomain Arch-Linux" >> /etc/hosts' && echo "Hostname OK" || exit 1

#Modify root password
arch-chroot /mnt bash -c 'echo "root:1234" | chpasswd' && echo "Root password configured" || exit 1

#Create User
arch-chroot /mnt bash -c 'useradd -m rcandau && echo "rcandau:4321" | chpasswd && usermod -aG wheel,audio,video,optical,storage,games rcandau' && echo "User created and configured" || exit 1

#Install and configure sudo
arch-chroot /mnt bash -c 'pacman -S --noconfirm sudo > /dev/null && sed -i "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /etc/sudoers' && echo "Sudo installed and configured" || exit 1

#Install and configure GRUB
echo "Installing and configuring GRUB. This might take a few minutes..." && arch-chroot /mnt bash -c 'pacman -S --noconfirm grub efibootmgr dosfstools mtools > /dev/null && mkdir /boot/EFI && mount /dev/sda1 /boot/EFI && grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck > /dev/null 2>&1 && grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1' && echo "GRUB installed and configured" || exit 1

#Install necessary/useful packages for the base of the system + Desktop environment
echo "Installing necessary and additional packages, drivers and DE. This might take a few minutes..." && arch-chroot /mnt bash -c 'pacman -S --noconfirm --needed networkmanager vim base-devel linux-headers intel-ucode nvidia xorg gnome > /dev/null 2>&1 && systemctl enable NetworkManager > /dev/null 2>&1 && systemctl enable gdm > /dev/null 2>&1' && echo "Packages installed" || exit 1

#Setup keyboard layout in X11
arch-chroot /mnt bash -c 'echo -e "Section \"InputClass\"\n        Identifier \"system-keyboard\"\n        MatchIsKeyboard \"on\"\n        Option \"XkbLayout\" \"fr\"\nEndSection" > /etc/X11/xorg.conf.d/00-keyboard.conf' && echo "Keyboard layout configured" || exit 1

#Update Grub configuration
arch-chroot /mnt bash -c 'grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1' && echo "Grub configuration updated" || exit 1

#Exit chroot and umount root partition
arch-chroot /mnt bash -c 'exit' && umount -l /mnt && echo "Umount root partition OK" || exit 1

echo ""
echo ""
echo ""
echo "Installation complete"
echo ""
echo ""
echo ""
echo "The computer will reboot automatically in a few second"
sleep 10 && reboot

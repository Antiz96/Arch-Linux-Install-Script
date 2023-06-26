#!/bin/bash

echo "Welcome to the Arch Linux Installer Script made by Robin Candau"
echo ""
echo "Don't forget to adapt it to your needs and preferences before using it (refer to the guide linked down below) !"
echo ""
echo "An internet connection is needed to use this script (which is required to install Arch Linux anyway)"
echo ""
echo "/!\ WARNING /!\\"
echo "Disk partitioning is NOT currently handled by this script"
echo "It may be handled in the future, if I find a good implementation for that feature"
echo "For now, you'll need to create your own partitions AND filesystems BEFORE using this script (refer to the guide linked down below)"
echo "Also, keep in mind that this script is meant to install Arch-Linux on a UEFI/EFI system"
echo ""
echo "A complete and easy guide to edit and use this script is available on the following link :"
echo "https://github.com/Antiz96/Arch-Linux-Install-Script"
echo ""
echo "My Github : https://github.com/Antiz96"
echo "My Linkedin : https://www.linkedin.com/in/robin-candau-3083a2173/"
echo "My Website : https://rc-linux.com"
echo ""
read -n 1 -r -s -p $'Press \"enter\" to continue or \"ctrl + c\" to abort\n'
echo ""
echo ""

#################################################################################################################

##Definition of variables##
##Edit them according to your needs/preferences##

#Defines the disk partition on which the system will be installed. You can list your current partitions with the "fdisk -l" command.
ROOT_PART="/dev/sda3"

#Defines the disk partition on which the bootloader (GRUB) will be installed. You can list your current partitions with the "fdisk -l" command.
BOOT_PART="/dev/sda1"

#Defines the linux kernel that will be installed on your system. You can choose between "linux" (latest linux kernel) or "linux-lts" (long term support linux kernel).
KERNEL="linux"

#Defines the timezone to configure in the system. You can list available timezones in the directory tree located in "/usr/share/zoneinfo".
TIMEZONE="Europe/Paris"

#Defines the language to configure in the system. You can list available languages by reading the "/etc/locale.gen" file. You need to get rid of the last "\*space\* UTF-8" at the end.
LANGUAGE="fr_FR.UTF-8"

#Defines the keyboard layout to configure in the system. You can list available keyboard layouts with the "localectl list-keymaps" command.
KEYMAP="fr"

#Defines the hostname to apply to your computer.
HOSTNAME="Arch-Linux"

#Defines the password for the root user.
ROOT_PWD="123456"

#Defines the username of your user.
USER_NAME="user1"

#Defines the password of your user.
USER_PWD="1234"

#Defines the CPU driver to install. You can choose between "intel-ucode" (for Intel CPU) or "amd-ucode" (for AMD CPU).
CPU="intel-ucode"

#Defines the GPU driver to install. You can choose between "nvidia" (for Nvidia GPU and Linux kernel), "nvidia-lts" (for Nvidia GPU and Linux-lts kernel) or "mesa" (for AMD GPU or Intel graphics).
GPU="nvidia"

#Defines the additional packages to install (such as useful packages for the system, Desktop environment, display manager, etc... Don't forget to modify the "systemctl enable" part depending on your choices.
PACKAGES() {
	pacman -S --noconfirm --needed networkmanager vim base-devel linux-headers bash-completion xorg gnome > /dev/null 2>&1 && systemctl enable NetworkManager > /dev/null 2>&1 && systemctl enable gdm > /dev/null 2>&1
}

#################################################################################################################

##Beginning of the script##
##You shouldn't modify those lines, unless you know exactly what you're doing## 

#Set NTP
timedatectl set-ntp true && echo "NTP configured" || exit 1

#Mount Root partition
mount $ROOT_PART /mnt && echo "Root partition \"$ROOT_PART\" correctly mounted" || exit 1

#Install Linux Kernel and base system
echo "Installing \"$KERNEL\" kernel and base system. This might take a few minutes..." && pacstrap /mnt base $KERNEL linux-firmware > /dev/null && echo "Linux kernel and base system installed" || exit 1

#Generating FSTAB
genfstab -U /mnt >> /mnt/etc/fstab && echo "FSTAB generated" || exit 1

#Set localtime
export TIMEZONE=$TIMEZONE && arch-chroot /mnt bash -c 'ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && hwclock --systohc' && echo "Timezone \"$TIMEZONE\" configured" || exit 1

#Set Language
export LANGUAGE=$LANGUAGE && export KEYMAP=$KEYMAP && arch-chroot /mnt bash -c 'sed -i "s/#$LANGUAGE UTF-8/$LANGUAGE UTF-8/" /etc/locale.gen && locale-gen > /dev/null && echo "LANG=$LANGUAGE" > /etc/locale.conf && echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf' && echo "Language \"$LANGUAGE\" configured" || exit 1

#Set Hostname
export HOSTNAME=$HOSTNAME && arch-chroot /mnt bash -c 'echo "$HOSTNAME" > /etc/hostname && echo -e "\n127.0.0.1       localhost\n::1             localhost\n127.0.1.1       $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts' && echo "Hostname \"$HOSTNAME\" configured" || exit 1

#Modify root password
export ROOT_PWD=$ROOT_PWD && arch-chroot /mnt bash -c 'echo "root:"$ROOT_PWD"" | chpasswd' && echo "Root password configured" || exit 1

#Create User
export USER_NAME=$USER_NAME && export USER_PWD=$USER_PWD && arch-chroot /mnt bash -c 'useradd -m $USER_NAME && echo "$USER_NAME:$USER_PWD" | chpasswd && usermod -aG wheel,audio,video,optical,storage,games $USER_NAME' && echo "User \"$USER_NAME\" created and configured" || exit 1

#Install and configure sudo
arch-chroot /mnt bash -c 'pacman -S --noconfirm sudo > /dev/null && sed -i "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /etc/sudoers' && echo "Sudo installed and configured" || exit 1

#Install and configure GRUB
export BOOT_PART=$BOOT_PART && echo "Installing and configuring GRUB. This might take a few minutes..." && arch-chroot /mnt bash -c 'pacman -S --noconfirm grub efibootmgr dosfstools mtools > /dev/null && mkdir /boot/EFI && mount $BOOT_PART /boot/EFI && grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck > /dev/null 2>&1 && grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1' && echo "GRUB installed and configured on boot partition \"$BOOT_PART\"" || exit 1

#Install necessary/useful packages for the base of the system + Desktop environment (and eventually Display Manager)
export CPU=$CPU && export GPU=$GPU && export -f PACKAGES && echo "Installing necessary and additional packages, drivers and desktop environment. This might take a few minutes..." && arch-chroot /mnt bash -c 'pacman -S --noconfirm $CPU $GPU > /dev/null 2>&1 && PACKAGES' && echo "Packages installed" || exit 1

#Setup keyboard layout in X11
arch-chroot /mnt bash -c 'echo -e "Section \"InputClass\"\n        Identifier \"system-keyboard\"\n        MatchIsKeyboard \"on\"\n        Option \"XkbLayout\" \"$KEYMAP\"\nEndSection" > /etc/X11/xorg.conf.d/00-keyboard.conf' && echo "Keyboard layout \"$KEYMAP\" configured" || exit 1

#Update Grub configuration
arch-chroot /mnt bash -c 'grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1' && echo "GRUB configuration updated" || exit 1

#Exit chroot and umount root partition
arch-chroot /mnt bash -c 'exit' && umount -l /mnt && echo "Root partition \"$ROOT_PART\" correctly unmounted" || exit 1

echo ""
echo "Installation complete"
echo ""
echo "Welcome to Arch-Linux :)"
echo ""
echo "The computer will reboot in a few seconds"
sleep 10 && reboot

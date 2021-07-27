#!/bin/bash

echo "Welcome to the Arch Linux Installer Script made by Robin Candau"
echo ""
echo "Don't forget to adapt it to your needs and preferences before using it (refer to the guide down below) !"
echo ""
echo "An internet connexion is needed to use this script (which is required to install Arch Linux anyway)"
echo ""
echo "/!\ WARNING /!\\"
echo "Disk partitioning is NOT handled by this script"
echo "Please, create your own partitions AND filesystems BEFORE using this script (refer to the guide down below)"
echo "Also, keep in mind that this script is meant to install Arch-Linux on a UEFI/EFI system"
echo ""
echo "A complete and easy guide to edit and use this script is available in the link down below"
echo "https://github.com/Antiz96/Arch-Linux-Install-Script"
echo ""
echo "My Github : https://github.com/Antiz96"
echo "My Linkedin : https://www.linkedin.com/in/robin-candau-3083a2173/"
echo "My Website : https://rc-linux.com"
echo ""
read -n 1 -r -s -p $'Press enter to continue or ctrl + c to abort\n'
echo ""
echo ""

#################################################################################################################

##Definition of variables##
##Edit them according to your needs/preferences##

#Define the Root partition (which will host your Arch-Linux system)
ROOT_PART="/dev/sda3"

#Define the Boot partition (which will host the GRUB bootloader)
BOOT_PART="/dev/sda1"

#Define the kernel type ("linux" for the latest linux kernel or "linux-lts" for the long term support linux kernel)
KERNEL="linux"

#Define the timezone (In the form "Continent/City". List of available timezones in the /usr/share/zoneinfo directory)
TIMEZONE="Europe/Paris"

#Define the language (List of available languages in the /etc/locale.gen file. Get rid of the "*space* UTF-8" at the end for this variable)
LANGUAGE="fr_FR.UTF-8"

#Define your keyboard layout (which will be configured for your all system. You can list all available keymaps with the "localectl list-keymaps" command) 
KEYMAP="fr"

#Define the hostname (The name of your computer)
HOSTNAME="Arch-Linux"

#Define the password of the root user (Please, change this)
ROOT_PWD="123456"

#Define the username of your user (Please, change this)
USER_NAME="rcandau"

#Define the password of your user (Please, change this)
USER_PWD="1234"

#Define your CPU driver type ("intel-ucode" for intel CPU or "amd-ucode" for AMD CPU)
CPU="intel-ucode"

#Define your GPU driver type ("nvidia" for nvidia GPU + Linux Kernel, "nvidia-lts" for nvidia GPU + Linux-LTS Kernel or "mesa" for AMD GPU and Intel Graphics"
GPU="nvidia"

#################################################################################################################

##Beginning of the script##
##You eventually may want to edit line "105" according to your preferences (in term of packages, Desktop Environment and Display Manager)## 

#Set NTP
timedatectl set-ntp true && echo "NTP configured" || exit 1

#Mount Root partition
mount $ROOT_PART /mnt && echo "Root partition \"$ROOT_PART\" correctly mounted" || exit 1

#Install Linux Kernel and base system
echo "Installating $KERNEL kernel and base system. This might take a few minutes..." && pacstrap /mnt base $KERNEL linux-firmware > /dev/null && echo "Linux Kernel and Base system installed" || exit 1

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
export CPU=$CPU && export GPU=$GPU && echo "Installing necessary and additional packages, drivers and Desktop environment. This might take a few minutes..." && arch-chroot /mnt bash -c 'pacman -S --noconfirm --needed networkmanager vim base-devel linux-headers $CPU $GPU xorg gnome > /dev/null 2>&1 && systemctl enable NetworkManager > /dev/null 2>&1 && systemctl enable gdm > /dev/null 2>&1' && echo "Packages installed" || exit 1

#Setup keyboard layout in X11
arch-chroot /mnt bash -c 'echo -e "Section \"InputClass\"\n        Identifier \"system-keyboard\"\n        MatchIsKeyboard \"on\"\n        Option \"XkbLayout\" \"$KEYMAP\"\nEndSection" > /etc/X11/xorg.conf.d/00-keyboard.conf' && echo "Keyboard layout \"$KEYMAP\" configured" || exit 1

#Update Grub configuration
arch-chroot /mnt bash -c 'grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1' && echo "Grub configuration updated" || exit 1

#Exit chroot and umount root partition
arch-chroot /mnt bash -c 'exit' && umount -l /mnt && echo "Root partition \"$ROOT_PART\" correctly unmounted" || exit 1

echo ""
echo "Installation complete"
echo ""
echo "Welcome to Arch-Linux :)"
echo ""
echo "The computer will reboot automatically in a few second"
sleep 10 && reboot

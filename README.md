# Arch Linux Install Script

A bash script I made to automate my VMs Arch Linux installations.  
It is easy to adapt to your needs/preferences (guide down below).

An internet connexion is needed to use this script (which is required to install Arch Linux anyway).

**WARNING**  
Disk partitioning is **NOT** currently handled by this script.  
It may be handled in the future, if I find a good implementation for that feature.  
For now, you'll need to **create your own partitions AND filesystems BEFORE using this script** (refer to the "Disk partitioning example" section down below).  
Also, keep in mind that this script is meant to install Arch-Linux on a **UEFI/EFI system**.

## Table of contents
* [Installation](#installation)
* [Configuration](#configuration)
* [Usage](#usage)
* [Disk partitioning example](#disk-partitioning-example)
* [Technologies and prerequisites](#technologies-and-prerequisites)


## Installation

Type the following command in your terminal :

`curl https://raw.githubusercontent.com/Antiz96/Arch-Linux-Install-Script/main/install-arch-linux.sh -O && chmod +x install-arch-linux.sh`


## Configuration

To configure the script according to your needs/preferences, you just have to edit it with your prefered text editor (vi, vim, nano, etc...) :

`vim install-arch-linux.sh`

All you need to do is to edit the different variables that are defined from line 28 to line 70, according to your needs/preferences.  
Here's a recap board of all the variables that you can **(and should)** edit :

Variable Name  |  Line  |  Default Value  | Comment
-------------  |  ----  |  -------------  | -------
ROOT_PART      |  32    |  /dev/sda3      | Defines the disk partition on which the system will be installed. You can list your current partitions with the "fdisk -l" command.
BOOT_PART      |  35    |  /dev/sda1      | Defines the disk partition on which the bootloader (GRUB) will be installed. You can list your current partitions with the "fdisk -l" command.
KERNEL	       |  38	|  linux	  | Defines the linux kernel that will be installed on your system. You can choose between "linux" (latest linux kernel) or "linux-lts" (long term support linux kernel).
TIMEZONE       |  41    |  Europe/Paris   | Defines the timezone to configure in the system. You can list available timezones in the directory tree located in "/usr/share/zoneinfo".
LANGUAGE       |  44	|  fr_FR.UTF-8	  | Defines the language to configure in the system. You can list available languages by reading the "/etc/locale.gen" file. You need to get rid of the last "\*space\* UTF-8" at the end. Example : fr_FR.UTF-8 ~~UTF-8~~.
KEYMAP	       |  47    |  fr             | Defines the keyboard layout to configure in the system. You can list available keyboard layouts with the "localectl list-keymaps" command.
HOSTNAME       |  50    |  Arch-Linux     | Defines the hostname to apply to your computer.
ROOT_PWD       |  53    |  123456         | Defines the password for the root user.
USER_NAME      |  56    |  user1          | Defines the username of your user.
USER_PWD       |  59    |  1234           | Defines the password of your user.
CPU	       |  62    |  intel-ucode    | Defines the CPU driver to install. You can choose between "intel-ucode" (for Intel CPU) or "amd-ucode" (for AMD CPU).
GPU            |  65    |  nvidia         | Defines the GPU driver to install. You can choose between "nvidia" (for Nvidia GPU and Linux kernel), "nvidia-lts" (for Nvidia GPU and Linux-lts kernel) or "mesa" (for AMD GPU or Intel graphics).     
PACKAGES       |  69    |  networkmanager vim base-devel linux-headers bash-completion xorg gnome  | Defines the additionnal packages to install (such as useful packages for the system, Desktop environment, display manager, etc... Don't forget to modify the "systemctl enable" part depending on your choices. **If you don't know what to put in this variable, just leave it as default. The default value contains necessary and useful packages for the system and the Gnome Desktop environment**.


## Usage

Once you edited the variables according to your needs/preferences, you can launch the script by typing the following command : 

`./install-arch-linux.sh`

Once the script has launched, you just need to press "enter" after you read the displayed information. The script will take care of the rest.

**If you haven't configured the script or did the disk partitioning/filesystem part yet, you can press "ctrl + c" to quit the script and do so before relaunching it**.

If everything went well, you should have the following output (emphasized part) :


*Welcome to the Arch Linux Installer Script made by Robin Candau*

*Don't forget to adapt it to your needs and preferences before using it (refer to the guide linked down below) !*

*An internet connexion is needed to use this script (which is required to install Arch Linux anyway)*

*/!\ WARNING /!\\  
Disk partitioning is NOT currently handled by this script  
It may be handled in the future, if I find a good implementation for that feature  
For now, you'll need to create your own partitions AND filesystems BEFORE using this script (refer to the guide linked down below)  
Also, keep in mind that this script is meant to install Arch-Linux on a UEFI/EFI system*

*A complete and easy guide to edit and use this script is available on the following link :  
https://github.com/Antiz96/Arch-Linux-Install-Script*

*My Github : https://github.com/Antiz96  
My Linkedin : https://www.linkedin.com/in/robin-candau-3083a2173/  
My Website : https://rc-linux.com*

*Press "enter" to continue or "ctrl + c" to abort*


*NTP configured   
Root partition "/dev/sda3" correctly mounted* --> The root partition may differ depending on what you configured  
*Installing "linux" kernel and base system. This might take a few minutes...* --> The kernel may differ depending on what you configured  
*Linux kernel and base system installed  
FSTAB generated  
Timezone "Europe/Paris" configured* --> The timezone may differ depending on what you configured  
*Language "fr_FR.UTF-8" configured* --> The language may differ depending on what you configured  
*Hostname "Arch-Linux" configured* --> The hostname may differ depending on what you configured  
*Root password configured  
User "user1" created and configured* --> The username may differ depending on what you configured  
*Sudo installed and configured  
Installing and configuring GRUB. This might take a few minutes...  
GRUB installed and configured on boot partition "/dev/sda1"* --> The boot partition may differ depending on what you configured  
*Installing necessary and additional packages, drivers and desktop environment. This might take a few minutes...  
Packages installed  
Keyboard layout "fr" configured* --> The keyboard layout may differ depending on what you configured  
*GRUB configuration updated  
Root partition "/dev/sda3" correctly unmounted* --> The root partition may differ depending on what you configured  

*Installation complete*

*Welcome to Arch-Linux :)*

*The computer will reboot in a few seconds*

If you get a different output and/or if the script stops prematurely, then something went wrong.  
In this case, verify that you have a working internet connexion, that you did your disk partitioning and filesystems correctly and that you correctly configured the script by editing the variables.


## Disk partitioning example

Disk partitioning is **NOT** currently handled by this script.  
It may be handled in the future, if I find a good implementation for that feature.  
For now, you'll need to **create your own partitions AND filesystems BEFORE using this script**.  
Also, keep in mind that this script is meant to install Arch-Linux on a **UEFI/EFI system**.  

I will not write a full tutorial on how to create your partitions and filesystem (resources are available all over the internet), but I'll show you how I personally do it.

I usually create 3 partitions : 

Partition Number  |  Size  |  Comment
----------------  |  ----  |  -------
1                 |  550M  |  Boot Partition to install the GRUB bootloader on it.
2                 |  4G    |  Swap Partition. This partition is not mandatory, althought I recommend doing it. The size of this partition may differ depending on the size of your RAM. Check this [link](https://itsfoss.com/swap-size/ "link title") for more details.
3                 |  All left free space |  Root Partition to install my system on it, softwares, etc...

**Listing my disk(s) to select the one I want to install Arch Linux on :**

root@archiso ~ # fdisk -l  
*Disk **/dev/sda**: 50 GiB, 53687091200 bytes, 104857600 sectors* --> The disk I want to install Arch Linux on is called "/dev/sda". You might have more than one disk ("/dev/sdb", "/dev/sdc", etc...) depending on your configuration, so make sure you selected the right one. Also, your disk can have a different name pattern. For instance, SSD NVME are usually called "/dev/nvme0n1".  
*Disk model: VBOX HARDDISK  
Units: sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  
I/O size (minimum/optimal): 512 bytes / 512 bytes*


*Disk /dev/loop0: 662.07 MiB, 694231040 bytes, 1355920 sectors  
Units: sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  
I/O size (minimum/optimal): 512 bytes / 512 bytes*

**Partitionning my disk :**

**You can press "m" at any time in fdisk to display the help. Changes will only be applied when you'll press "w". You can press "q" at any time to discard changes.**    
**The following steps will completely erase all data on the selected disk, so make sure you have a valid save of things you want to keep.**

root@archiso ~ # fdisk /dev/sda

*Welcome to fdisk (util-linux 2.37.1).  
Changes will remain in memory only, until you decide to write them.  
Be careful before using the write command.*

*Device does not contain a recognized partition table.  
Created a new DOS disklabel with disk identifier 0xfc97131c.*

*Command (m for help):* **o** --> Delete all current partitions.  
*Created a new DOS disklabel with disk identifier 0xc4767950.*

*Command (m for help):* **g** --> Create a new GTP partition table.  
*Created a new GPT disklabel (GUID: BEEE4FE3-5DC8-9743-917C-94F934651527).*

*Command (m for help):* **n** --> Create a new partition.  
*Partition number (1-128, default 1):* --> Creation of the first partition, which is the one selected by default. You can either type "1" to specify the partition number, or press "enter" to use the default value (which is the same here).   
*First sector (2048-104857566, default 2048):* --> Leave this as default by pressing "enter".  
*Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-104857566, default 104857566):* **+550M** --> Select the size of the partition by typing "+" followed by the value and the unit. Here, we're creating a 550 megabytes partition.

*Created a new partition 1 of type 'Linux filesystem' and of size 550 MiB.*

*Command (m for help):* **n** --> Create a new partition.  
*Partition number (2-128, default 2):* --> Creation of the second partition, which is the one selected by default. You can either type "2" to specify the partition number, or press "enter" to use the default value (which is the same here).   
*First sector (1128448-104857566, default 1128448):* --> Leave this as default by pressing "enter".  
*Last sector, +/-sectors or +/-size{K,M,G,T,P} (1128448-104857566, default 104857566):* **+4G** --> Select the size of the partition. Here, we're creating a 4 gigabytes partition.

*Created a new partition 2 of type 'Linux filesystem' and of size 4 GiB.*

*Command (m for help):* **n** --> Create a new partition.  
*Partition number (3-128, default 3):* --> Creation of the third partition, which is the one selected by default. You can either type "3" to specify the partition number, or press "enter" to use the default value (which is the same here).  
*First sector (9517056-104857566, default 9517056):* --> Leave this as default by pressing "enter".  
*Last sector, +/-sectors or +/-size{K,M,G,T,P} (9517056-104857566, default 104857566):* --> As we want to assign all the left space available to this partition, press "enter" to leave this as default.

*Created a new partition 3 of type 'Linux filesystem' and of size 45.5 GiB.*

*Command (m for help):* **t** --> The three partitions are now created, we will assign them a specific type by typing "t".  
*Partition number (1-3, default 3):* **1** --> Select partition "1" by typing "1".  
*Partition type or alias (type L to list all):* **1** --> Select the code associated to the type you want (you can display them by typing "L"). The boot partition has to have an "EFI" type, which is associated to code 1. Type "1".  

*Changed type of partition 'Linux filesystem' to 'EFI System'.*

*Command (m for help):* **t** --> Press "t" once again to change the partition "2" type.  
*Partition number (1-3, default 3):* **2** --> Select partition "2" by typing "2".  
*Partition type or alias (type L to list all):* **19** --> The swap partition has to have a "swap" type, which is associated to code 19. Type "19"

*Changed type of partition 'Linux filesystem' to 'Linux swap'.*

*Command (m for help):* **p** --> We do not need to change the partition 3 type as the default type is "Linux filesystem" (code 20)  which is the one we want for the third partition. Now we're gonna print the result to check if everything is ok by typing "p".  
*Disk /dev/sda: 50 GiB, 53687091200 bytes, 104857600 sectors  
Disk model: VBOX HARDDISK  
Units: sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  
I/O size (minimum/optimal): 512 bytes / 512 bytes  
Disklabel type: gpt  
Disk identifier: BEEE4FE3-5DC8-9743-917C-94F934651527*

***Device       Start       End  Sectors  Size Type  
/dev/sda1     2048   1128447  1126400  550M EFI System  
/dev/sda2  1128448   9517055  8388608    4G Linux swap  
/dev/sda3  9517056 104857566 95340511 45.5G Linux filesystem***

*Command (m for help):* **w** --> If everything is ok, type "w" to save and apply changes. If you didn't set your partitions correctly, press "q" to quit without saving the changes and redo this whole part again.  
*The partition table has been altered.  
Calling ioctl() to re-read partition table.  
Syncing disks.*

**Creating the filesystems**

root@archiso ~ # mkfs.fat -F32 /dev/sda1 --> Creating the "FAT32" filesystem for the boot partition.  
*mkfs.fat 4.2 (2021-01-31)*

root@archiso ~ # mkswap /dev/sda2 --> Creating the "swap" filesystem for the swap partition.  
*Setting up swapspace version 1, size = 4 GiB (4294963200 bytes)  
no label, UUID=c18a338d-4047-46f7-b08c-04e8709e8123*  
root@archiso ~ # swapon /dev/sda2 --> Activating the swap partition.

root@archiso ~ # mkfs.ext4 /dev/sda3 --> Creating the "ext4" filesystem (which is the "default" one on Linux) for the root partition.  
*mke2fs 1.46.3 (27-Jul-2021)  
Creating filesystem with 11917563 4k blocks and 2981888 inodes  
Filesystem UUID: a3e46736-f2fb-4c35-9dd5-2b3bfc681dca  
Superblock backups stored on blocks:*    
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424

*Allocating group tables: done  
Writing inode tables: done  
Creating journal (65536 blocks): done  
Writing superblocks and filesystem accounting information: done*

**You are now ready to launch the script, it will take care of the rest !  
Don't forget to edit the "ROOT_PART" and "BOOT_PART" variables in the script according to the way you did your disk partitioning.**


## Technologies and prerequisites

This script has been entirely written with bash.

An internet connexion is needed to use this script (which is required to install Arch Linux anyway).  
The disk partitionning part is not currently handled by this script, so you need to do your disk partitioning and filesystems yourself before using it.

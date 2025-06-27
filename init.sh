#!/bin/sh
git clone https://github.com/atanvarno69/arch-install.git /root/arch-install >/dev/null
rm -rf /root/arch-install/.git
. /root/arch-install/init/fstab.sh
. /root/arch-install/init/font.sh
. /root/arch-install/init/mkinitcpio.sh
. /root/arch-install/init/bootloader.sh
rm -rf /root/arch-install/init
mkdir /usr/share/arch-install
touch /usr/share/arch-install/installed
chmod 0666 /usr/share/arch-install/installed

#!/bin/sh
sed -i "s|^HOOKS=(.*$|#HOOKS#|" /etc/mkinitcpio.conf
sed -i "s|#HOOKS#|HOOKS=(systemd keyboard autodetect microcode modconf kms sd-vconsole block filesystems fsck)|" /etc/mkinitcpio.conf
mkinitcpio -P

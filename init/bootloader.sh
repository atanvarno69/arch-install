#!/bin/sh
mkdir -p /etc/pacman.d/hooks
tee /etc/pacman.d/hooks/95-systemd-boot.hook >/dev/null <<'EOF'
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Gracefully upgrading systemd-boot...
When = PostTransaction
Exec = /usr/bin/systemctl restart systemd-boot-update.service
EOF
if [ -d /efi ]; then
    bootctl --boot-path=/boot --esp-path=/efi install >/dev/null 2>&1
else
    bootctl install >/dev/null 2>&1
fi
sed -i "s|^timeout .*$|timeout 3|" /boot/loader/loader.conf
tee -a /boot/loader/loader.conf >/dev/null <<'EOF'
console-mode  max
editor        no
EOF
[ -f /boot/intel-ucode.img ] && ucode='/intel-ucode.img'
[ -f /boot/amd-ucode.img ] && ucode='/amd-ucode.img'
for file in /boot/loader/entries/*; do
    [ -n "${ucode}" ] && sed -i "s|^initrd|initrd  ${ucode}\ninitrd|" "${file}"
done
[ -d /efi ] && . /root/arch-install/init/firmware.sh

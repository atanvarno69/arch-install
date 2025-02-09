#!/bin/sh

# Trash /etc/fstab
tee /etc/fstab >/dev/null <<'EOF'
# Static information about the filesystems.
# See fstab(5) for details.
EOF

# mkinitcpio
sed -i "s|^HOOKS=(.*$|#HOOKS#|" /etc/mkinitcpio.conf
sed -i "s|#HOOKS#|HOOKS=(systemd keyboard autodetect microcode modconf kms sd-vconsole block filesystems fsck)|" /etc/mkinitcpio.conf
mkinitcpio -P

# Bootloader update hook
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

# Bootloader install
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

[ ! -d /efi ] && exit 0
mv /boot/loader/loader.conf /efi/loader/loader.conf

# XBOOTLOADER partition firmware
pacman -S --asexplicit --needed --noconfirm efifs

if pacman -Q efifs >/dev/null 2>&1; then
    packages=$(pacman -Qq)
    firmware=''
    if echo "${packages}" | grep -s -q 'btrfs-progs'; then firmware="${firmware} /usr/lib/efifs-x64/btrfs_x64.efi"; fi
    if echo "${packages}" | grep -s -q 'exfatprogs'; then firmware="${firmware} /usr/lib/efifs-x64/exfat_x64.efi"; fi
    if echo "${packages}" | grep -s -q 'f2fs-tools'; then firmware="${firmware} /usr/lib/efifs-x64/f2fs_x64.efi"; fi
    if echo "${packages}" | grep -s -q 'e2fsprogs'; then firmware="${firmware} /usr/lib/efifs-x64/ext2_x64.efi"; fi
    if echo "${packages}" | grep -s -q 'jfsutils'; then firmware="${firmware} /usr/lib/efifs-x64/jfs_x64.efi"; fi
    if echo "${packages}" | grep -s -q 'nilfs-utils'; then firmware="${firmware} /usr/lib/efifs-x64/nilfs2_x64.efi"; fi
    if echo "${packages}" | grep -s -q 'ntfs-3g'; then firmware="${firmware} /usr/lib/efifs-x64/ntfs_x64.efi"; fi
    if echo "${packages}" | grep -s -q 'udftools'; then firmware="${firmware} /usr/lib/efifs-x64/udf_x64.efi"; fi
    if echo "${packages}" | grep -s -q 'xfsprogs'; then firmware="${firmware} /usr/lib/efifs-x64/xfs_x64.efi"; fi
    firmware=$(echo "${firmware}" | xargs echo)
fi

[ -z "${firmware}" ] && exit 0

mkdir -p /efi/EFI/systemd/drivers
cp -f ${firmware} /efi/EFI/systemd/drivers
tee /etc/pacman.d/hooks/efifs.hook >/dev/null <<EOF
[Trigger]
Type = Package
Operation = Upgrade
Target = efifs

[Action]
Description = Upgrading bootloader EFI firmware...
When = PostTransaction
Exec = /usr/bin/cp -f ${firmware} /efi/EFI/systemd/drivers
EOF


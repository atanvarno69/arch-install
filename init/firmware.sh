#!/bin/sh
mv /boot/loader/loader.conf /efi/loader/loader.conf
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

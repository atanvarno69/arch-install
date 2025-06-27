#!/bin/sh

dir=$(CDPATH= cd -- "$(dirname -- "${0}")" && pwd -P)

cp -r /etc/skel/. /root
for file in /root/.bash_logout /root/.bash_logout /root/.bashrc; do
    [ -f "${file}" ] && rm "${file}"
done

[ -d ] /root/.gnupg && rmdir /root/.local/share/gnupg && mv /root/.gnupg /root/.local/share/gnupg
[ -f ] /root/.config/starship/starship.toml && sed -i 's|\\$]|#]|' /root/.config/starship/starship.toml

pacman -Syu --noconfirm

rm -rf /usr/share/arch-install "${dir}/../.."

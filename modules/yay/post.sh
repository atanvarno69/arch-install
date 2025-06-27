#!/bin/sh

temp_sudoers_file=/etc/sudoers.d/99-nobody-temp
build_dir=/home/build

tee "${temp_sudoers_file}" >/dev/null <<'EOF'
nobody ALL= NOPASSWD: /usr/bin/pacman
EOF

mkdir "${build_dir}"
chgrp nobody "${build_dir}"
chmod g+ws "${build_dir}"
setfacl -m u::rwx,g::rwx "${build_dir}"
setfacl -d --set u::rwx,g::rwx,o::- "${build_dir}"
git clone https://aur.archlinux.org/yay-bin.git "${build_dir}/yay"

sudo -D "${build_dir}/yay" -u nobody makepkg -si

rm -rf "${temp_sudoers_file}" /home/build

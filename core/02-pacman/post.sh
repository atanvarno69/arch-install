#!/bin/sh

[ ! -d /etc/pacman.d/hooks ] && mkdir -p /etc/pacman.d/hooks

sed -i "s|^# Misc options|# Misc options\nILoveCandy|" /etc/pacman.conf
sed -i "s|^#Color|Color|" /etc/pacman.conf
sed -i "s|^#VerbosePkgLists|VerbosePkgLists|" /etc/pacman.conf
sed -i "s|^#ParallelDownloads.*$|ParallelDownloads = 4|" /etc/pacman.conf

iso=$(curl -4 ifconfig.co/country-iso)

tee /etc/xdg/reflector/reflector.conf >/dev/null <<EOF
--save /etc/pacman.d/mirrorlist
--sort score
--age 48
--country ${iso}
--fastest 5
--latest 10
--protocol https
EOF

systemctl enable paccache.timer
echo "Running reflector..."
systemctl enable --now reflector.timer
echo "Done"

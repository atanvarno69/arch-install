#!/bin/sh
if pacman -Q terminus-font >/dev/null 2>&1; then
    tee -a /etc/vconsole.conf >/dev/null <<'EOF'
FONT=ter-116n
FONT_MAP=8859-1
EOF
    systemctl restart systemd-vconsole-setup.service
fi

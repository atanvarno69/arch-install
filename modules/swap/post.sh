#!/bin/sh

tee /etc/systemd/zram-generator.conf >/dev/null <<'EOF'
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF

systemctl daemon-reload
systemctl enable --now systemd-zram-setup@zram0.service

#!/bin/sh

mkdir -p /etc/skel/.config/git

tee /etc/skel/.config/git/config >/dev/null <<'EOF'
[init]
    defaultBranch = main
EOF

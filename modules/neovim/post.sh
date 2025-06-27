#!/bin/sh

mkdir -p /etc/skel/.config/nvim
touch /etc/skel/.config/nvim/init.lua

tee -a /etc/skel/.config/zsh/zshrc >/dev/null <<'EOF'
export VISUAL=nvim
export EDITOR="${VISUAL}"
EOF

#!/bin/sh

mkdir /etc/skel/.config/bat

tee -a /etc/skel/.config/zsh/aliases >/dev/null <<'EOF'
alias man='batman'
EOF

tee -a /etc/skel/.config/zsh/zshrc >/dev/null <<'EOF'
export PAGER=bat
export BAT_PAGER='less -RF'
EOF

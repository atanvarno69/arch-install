#!/bin/sh

tee -a /etc/skel/.config/zsh/aliases >/dev/null <<'EOF'
alias rm='trash'
alias rmdir='trash'
EOF

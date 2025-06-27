#!/bin/sh

tee -a /etc/skel/.config/zsh/aliases >/dev/null <<'EOF'
alias z='zoxide'
EOF

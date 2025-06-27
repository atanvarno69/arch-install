#!/bin/sh

mkdir /etc/skel/.local/share/gnupg

tee -a /etc/skel/.config/zsh/zshenv >/dev/null <<'EOF'
[ -z "${GNUPGHOME}" ] && export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
EOF

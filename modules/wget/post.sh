#/bin/sh

mkdir /etc/skel/.config/wget
touch /etc/skel/.config/wget/wgetrc

tee -a /etc/skel/.config/zsh/zshenv >/dev/null <<'EOF'
[ -z "${WGETRC}" ] && export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"
EOF


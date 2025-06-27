#!/bin/sh

tee -a /etc/skel/.config/zsh/aliases >/dev/null <<'EOF'
alias ls='eza --color=auto'
alias l='ls -a -X --group-directories-first'
alias ll='ls -a -X -l -g --time-style="+%y/%m/%d %H:%M" --group-directories-first'
alias la='ls -aa -l -g --time-style="+%y/%m/%d %H:%M:%S" --group-directories-first'
alias list='ls -1 -a -X --group-directories-first'
alias ld='l -D'
alias lf='l -f'
alias lld='ll -D'
alias llf='ll -f'
alias lad='la -D'
alias laf='la -f'
EOF

tee -a /etc/skel/.config/zsh/zshrc >/dev/null <<'EOF'
export EZA_ICON_SPACING=2
export EZA_ICONS_AUTO=1
EOF

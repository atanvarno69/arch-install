#!/bin/sh

rm -f /etc/skel/.bash_logout /etc/skel/.bash_profile /etc/skel/.bashrc
sed -i "s|bash|zsh|" /etc/passwd /etc/default/useradd
mkdir -p /etc/skel/.config/zsh /etc/skel/.local/share/zsh /etc/skel/.local/state/zsh /etc/skel/.cache/zsh /etc/zsh/zdotdir

tee /etc/zsh/zshenv >/dev/null <<'EOF'
if [[ ! -o norcs ]]; then
    [ -z "${ZDOTDIR}" ] && export ZDOTDIR="/etc/zsh/zdotdir"
    [ -z "${XDG_DATA_DIRS}" ] && export XDG_DATA_DIRS="/usr/local/share/:/usr/share/"
    [ -z "${XDG_CONFIG_DIRS}" ] && export XDG_CONFIG_DIRS="/etc/xdg"
fi
true
EOF

for filename in "zlogin" "zlogout" "zprofile" "zshenv" "zshrc"; do tee "/etc/zsh/zdotdir/.${filename}" >/dev/null <<EOF
[ -f "\${HOME}/.config/zsh/${filename}" ] && source "\${HOME}/.config/zsh/${filename}"
true
EOF
    touch "/etc/skel/.config/zsh/${filename}"
done

touch /etc/skel/.config/zsh/prompt /etc/skel/.config/zsh/aliases

tee /etc/skel/.config/zsh/zshenv >/dev/null <<'EOF'
[ -z "${XDG_CACHE_HOME}" ] && export XDG_CACHE_HOME="${HOME}/.cache"
[ -z "${XDG_CONFIG_HOME}" ] && export XDG_CONFIG_HOME="${HOME}/.config"
[ -z "${XDG_DATA_HOME}" ] && export XDG_DATA_HOME="${HOME}/.local/share"
[ -z "${XDG_STATE_HOME}" ] && export XDG_STATE_HOME="${HOME}/.local/state"

[ -z "${MAKEFLAGS}" ] && export MAKEFLAGS="--jobs=$(nproc)"

[ -z "${GNUPGHOME}" ] && export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
EOF

tee /etc/skel/.config/zsh/zshrc >/dev/null <<'EOF'
typeset -U path
[ -d "${HOME}/.local/bin" ] && path=("${HOME}/.local/bin" $path)
typeset -U fpath
[ -d "${HOME}/.local/functions" ] && fpath=("${HOME}/.local/functions" $fpath)
bindkey -e
autoload -Uz compinit; compinit -d "${XDG_CACHE_HOME}/zsh/compdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion::complete:*' gain-privileges 1
setopt append_history correct extended_history hist_ignore_dups hist_ignore_space hist_no_functions hist_no_store hist_reduce_blanks inc_append_history share_history
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f "${XDG_CONFIG_HOME}/zsh/aliases" ] && source "${XDG_CONFIG_HOME}/zsh/aliases"
[ -f "${XDG_CONFIG_HOME}/zsh/prompt" ] && source "${XDG_CONFIG_HOME}/zsh/prompt"
[ -f "${XDG_CONFIG_HOME}/zsh/highlighting" ] && source "${XDG_CONFIG_HOME}/zsh/highlighting"
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=1000
SAVEHIST=1000
EOF

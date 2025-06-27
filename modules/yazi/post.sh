#!/bin/sh

mkdir /etc/skel/.config/yazi

touch /etc/skel/.config/yazi/yazi.toml

tee /etc/skel/.local/functions/ycd >/dev/null <<'EOF'
function ycd() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "${@}" --cwd-file="${tmp}"
    if cwd="$(command cat -- "${tmp}")" && [ -n "${cwd}" ] && [ "${cwd}" != "${PWD}" ]; then
        builtin cd -- "${cwd}"
    fi
    rm -f -- "${tmp}"
}
EOF

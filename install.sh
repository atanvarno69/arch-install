#!/bin/sh

version_number="0.1.0-dev"
help=0
version=0
while [ -n "${1}" ]; do
    case "${1}" in
        -h|--help) help=1;;
        -V|--version) version=1;;
        --) shift; break;;
        -*) echo "Unrecognized option ${1}" 1>&2; exit 1;;
        *) break;;
    esac
    shift
done

get_modules() {
    for name in "${1}"/*; do
        if [ -f "${name}/description.txt" ]; then
            output=$(cat "${name}/description.txt")
        else
            output="UNDEFINED"
        fi
        echo "|$(basename "${name}")|${output}"
    done
}

dir=$(CDPATH= cd -- "$(dirname -- "${0}")" && pwd -P)

if [ "${help}" -gt 0 ]; then
    tee /dev/null <<'EOF'

  arch-install - helper tools for an Arch Linux installation

USAGE
  install [OPTION...] [--] [MODULE...]

OPTIONS
  -h, --help     Print this help text and exit.
  -V, --version  Print version information and exit.

MODULE
  The name of a module. Each module installs packages and/or applies system configuration.

EOF
    get_modules "${dir}/modules" | column -t -N SPACER,MODULE,DESCRIPTION -W DESCRIPTION -d -c 120 -s "|"
    tee /dev/null <<'EOF'

AUR MODULE
  These modules require the yay module and can not be run as the root user.

EOF
    get_modules "${dir}/aur" | column -t -N SPACER,MODULE,DESCRIPTION -W DESCRIPTION -d -c 120 -s "|"
    echo ""
    exit 0
fi

[ "${version}" -gt 0 ] && echo "${version_number}" && exit 0

run_module() {
    [ "$(id -u)" -ne 0 ] && { echo "Must be superuser" 1>&2; exit 1; }
    [ -f "${dir}/${1}/pre.sh" ] && . "${dir}/${1}/pre.sh"
    [ -f "${dir}/${1}/packages.list" ] && xargs --arg-file="${dir}/${1}/packages.list" pacman -S --noconfirm --needed && xargs --arg-file="${dir}/${1}/packages.list" pacman -D --asexplicit
    [ -f "${dir}/${1}/dependencies.list" ] && xargs --arg-file="${dir}/${1}/packages.list" pacman -S --asdeps --needed --noconfirm
    [ -f "${dir}/${1}/post.sh" ] && . "${dir}/${1}/post.sh"
}

run_aur() {
    if ! is_installed "yay" && [ "${1}" != "yay" ]; then
        echo "Module yay must be installed first" 1>&2
        exit 1
    fi
    [ "$(id -u)" -eq 0 ] && { echo "Must not be superuser" 1>&2; exit 1; }
    [ -f "${dir}/${1}/pre.sh" ] && . "${dir}/${1}/pre.sh"
    [ -f "${dir}/${1}/packages.list" ] && xargs --arg-file="${dir}/${1}/packages.list" yay -S --needed && xargs --arg-file="${dir}/${1}/packages.list" yay -D --asexplicit
    [ -f "${dir}/${1}/dependencies.list" ] && xargs --arg-file="${dir}/${1}/packages.list" yay -S --asdeps --needed
    [ -f "${dir}/${1}/post.sh" ] && . "${dir}/${1}/post.sh"
}

is_installed() {
    if grep -qs "^${1}$" /usr/share/arch-install/installed; then
        return 0
    fi
    return 1
}

if is_installed "commit"; then
    echo "Configuration committed; no more modules may be installed" 1>&2
    exit 1
fi

if ! is_installed "core"; then
    [ "$(id -u)" -ne 0 ] && { echo "Must be superuser for first run" 1>&2; exit 1; }
    for module in "${dir}/core/"*; do
        run_module "${module}"
    done
fi

while [ -n "${1}" ]; do
    is_installed "commit" && { echo "Configuration committed; no more modules may be installed" 1>&2; exit 1; }
    is_installed "${1}" && { echo "Module ${1} already installed" 1>&2; exit 1; }
    if [ -d "${dir}/modules/${1}" ]; then
        run_module "${dir}/modules/${1}"
    elif [ -d "${dir}/aur/${1}" ]; then
        run_aur "${dir}/aur/${1}"
    else
        echo "Unrecognized module ${1}" 1>&2
        exit 1
    fi
    echo "${1}" >> /usr/share/arch-install/installed
    shift
done

exit 0

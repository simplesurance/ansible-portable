#!/usr/bin/env bash
set -euo pipefail

function usage() {
    echo "Arguments: <VERSION> <INSTALL_DIR> [ BIN_DIR ]"
}

function err() {
    echo "!! $@" >&2
}

function err_exit() {
    err $@
    exit 1
}

if [ "$#" -lt 1 ]; then
    err "Not enough arguments"
    usage
    exit 1
fi

version="$1"
install_dir="$2"
bin_dir="${3:-}"

mkdir -p "$install_dir" || err_exit "Could not create installation directory"
if [ ! -x "$install_dir" ]; then
    err_exit "Install directory is not writable"
fi

if [[ -n "${bin_dir}" && ! -d "${bin_dir}" ]]; then
    err_exit "Bin directory does not exist"
fi

install_dir="$(cd "$install_dir" && pwd -P)"
tmpdir="$(mktemp -d)"

echo "** Downloading..."

curl -fSL \
    https://github.com/simplesurance/ansible-portable/releases/download/v${version}/ansible-portable.tar.gz \
    -o "${tmpdir}/ansible-portable.tar.gz" \
    || err_exit "An error occurred downloading ansible-portable version ${version}"

echo "** Uncompressing..."
tar -C "${install_dir}" -xzf ${tmpdir}/ansible-portable.tar.gz \
    || err_exit "Failed uncompressing ansible-portable tarball"

rm -rf "${tmpdir}"

if [ -n "${bin_dir}" ]; then
    echo "** Linking..."
    cd "${bin_dir}"
    for l in "${install_dir}"/ansible*; do
        name="$(basename "$l")"
        echo "${install_dir}/${name} -> ${bin_dir}/${name}"
        ln -sfr "${install_dir}/${name}"
    done
fi

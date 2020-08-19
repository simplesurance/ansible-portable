#!/usr/bin/env bash
set -euo pipefail

function usage() {
    echo "Arguments: <VERSION> [ INSTALL_DIR ] [ BIN_DIR ]"
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

version="$1"             # which version to install
install_path="${2:-"."}" # defaults to current dir
bin_dir="${3:-}"         # creates links in this directory (by default no linking is performed)

mkdir -p "$install_path" || err_exit "Could not create installation directory"
if [ ! -x "$install_path" ]; then
    err_exit "Install directory is not writable"
fi

if [[ -n "${bin_dir}" && ! -d "${bin_dir}" ]]; then
    err_exit "Bin directory does not exist"
fi

install_path="$(cd "$install_path" && pwd -P)"
tmpdir="$(mktemp -d)"

## download
echo "** Downloading..."
curl -fSL \
    "https://github.com/simplesurance/ansible-portable/releases/download/v${version}/ansible-portable-${version}.tar.gz" \
    -o "${tmpdir}/ansible-portable.tar.gz" \
    || err_exit "An error occurred downloading ansible-portable version ${version}"

## uncompress
echo "** Uncompressing..."
tar -C "${install_path}" -xzf "${tmpdir}/ansible-portable.tar.gz" \
    || err_exit "Failed uncompressing ansible-portable tarball"

## cleanup
rm -rf "${tmpdir}"

## link
if [ -n "${bin_dir}" ]; then
    echo "** Linking..."
    cd "${bin_dir}"
    for l in "${install_path}"/ansible*; do
        name="$(basename "$l")"
        echo "${install_path}/${name} -> ${bin_dir}/${name}"
        ln -sfr "${install_path}/${name}"
    done
fi

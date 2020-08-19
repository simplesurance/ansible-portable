#!/usr/bin/env bash
set -euo pipefail

function usage() {
    echo "Arguments: <VERSION>"
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

version="$1" # which version to update to

script_path="$(cd "$(dirname "$0")"; pwd -P)"
install_path="$(cd "${script_path}/.."; pwd -P)"

if [ ! -x "$install_path" ]; then
    err_exit "Install directory is not writable"
fi

install_path="$(cd "$install_path"; pwd -P)"

if [[ -f "${install_path}/RELEASE" && "$(head -1 "${install_path}/RELEASE")" == "${version}" ]]; then
    echo "Nothing to update. If you wish to force an update remove the RELEASE file and re-run this script."
    exit 0
fi

tmpdir="$(mktemp -d)"

## download
echo "** Downloading..."
curl -fSL \
    "https://github.com/simplesurance/ansible-portable/releases/download/v${version}/ansible-portable-${version}.tar.gz" \
    -o "${tmpdir}/ansible-portable.tar.gz" \
    || err_exit "An error occurred downloading ansible-portable version ${version}"

## uncompress
echo "** Uncompressing..."
tar -C "${tmpdir}" -xzf "${tmpdir}/ansible-portable.tar.gz" && rm -f "${tmpdir}/ansible-portable.tar.gz" \
    || err_exit "Failed uncompressing ansible-portable tarball"

## backup
rm -rf "${install_path}.bak"
mv "${install_path}" "${install_path}.bak"

## move into place
mv "${tmpdir}" "${install_path}"
rm -rf "${install_path}.bak"

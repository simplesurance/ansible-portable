#!/usr/bin/env bash
set -euo pipefail

ANSIBLE_PORTABLE_VERSION=0.4.2
ANSIBLE_PLUGINS_VERSION=0.0.8

function install_ansible_portable() {
    cd tmp
    curl -L \
        https://github.com/ownport/portable-ansible/releases/download/v${ANSIBLE_PORTABLE_VERSION}/portable-ansible-v${ANSIBLE_PORTABLE_VERSION}-py3.tar.bz2 \
        -o portable-ansible.tar.bz2
    tar -xjf portable-ansible.tar.bz2
    rm -f portable-ansible.tar.bz2

    rm -rf ../src/ansible
    mv ansible/ ../src/
    cd - &>/dev/null
}

function install_custom_plugins() {
    cd tmp
    curl -L https://github.com/simplesurance/ansible-plugins/archive/v${ANSIBLE_PLUGINS_VERSION}.tar.gz -o ansible-plugins.tar.gz
    tar -xzf ansible-plugins.tar.gz
    rm -f ansible-plugins.tar.gz

    rm -rf ../plugins/*
    cp -rf ansible-plugins-${ANSIBLE_PLUGINS_VERSION}/{callback,filter,lookup,modules} ../plugins/
    cd - &>/dev/null
}

function install_requirements() {
    pip install -t src/ansible/extras -r requirements.txt
}


script_path="$(cd "$(dirname "$0")"; pwd -P)"
cd "$script_path"

rm -rf tmp; mkdir -p tmp

trap "{ rm -rf ${script_path}/tmp; }" EXIT

install_ansible_portable
install_custom_plugins
install_requirements

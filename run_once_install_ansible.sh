#!/bin/bash

# Credit to github.com/logandonley for this script
# https://github.com/logandonley/dotfiles/blob/main/run_once_install_ansible.sh

set -eu  # Strict mode

install_on_fedora() {
    sudo dnf install -y ansible
}

install_on_ubuntu() {
    sudo apt-get update -qq
    sudo apt-get install -qq ansible
}

install_on_mac() {
    brew install ansible
}

OS="$(uname -s)"
case "${OS}" in
    Linux*)
        if [ -f /etc/lsb-release ]; then
            install_on_ubuntu
        else
            echo "Unsupported Linux distribution"
            exit 1
        fi
        ;;
    #Darwin*)
    #    install_on_mac
    #    ;;
    *)
        echo "Unsupported operating system: ${OS}"
        exit 1
        ;;
esac


ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass

echo "Ansible installation complete."

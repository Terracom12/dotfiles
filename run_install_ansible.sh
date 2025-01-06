#!/bin/bash

# Credit to github.com/logandonley for this script
# https://github.com/logandonley/dotfiles/blob/main/run_once_install_ansible.sh

set -eu  # Strict mode

# Define ANSI escape color codes
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'
nc='\033[0m' # No Color


# Paths
playbook_path="${HOME}/.bootstrap/setup.yml"
playbook_hash_path="${HOME}/.bootstrap/.setup.yml.hash"

install_on_ubuntu() {
    sudo apt-get update -qq --no-install-recommends
    sudo apt-get install -qq --no-install-recommends ansible
}

OS="$(uname -s)"
case "${OS}" in
    Linux*)
        if [ -f /etc/lsb-release ]; then
            if ! ansible --version >& /dev/null; then
                echo -e "${yellow}Installing ansible${nc}"
                install_on_ubuntu
                echo -e "${green}Ansible installation complete${nc}"
            fi
        else
            echo -e "${red}Unsupported Linux distribution${nc}"
            exit 1
        fi
        ;;
    *)
        echo -e "${red}Unsupported operating system: ${OS}${nc}"
        exit 1
        ;;
esac

if ! command -v ansible &> /dev/null; then
    echo -e "${red}Failed to install ansible${nc}"
    exit 1
fi

playbook_hash="$(md5sum "${playbook_path}" || echo "")"
if [[ ! -f "${playbook_hash_path}" ]] || [[ "${playbook_hash}" != "$(cat "${playbook_hash_path}")" ]]; then
    echo -e "${yellow}Ansible playbook at '${playbook_path}' changed. Running ansible...${nc}"
    ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass -v
    echo "${playbook_hash}" > "${playbook_hash_path}"
else
    echo -e "${green}Ansible playbook unchanged. Nothing to do.${nc}"
fi


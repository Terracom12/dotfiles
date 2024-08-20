#!/bin/bash

d=$(pwd)

get_list () {
	cat $d/pkgs/$1.list | tr '\n' ' ' | xargs echo
}

sudo apt-get install -y $(get_list apt)

mkdir ~/Install
cd ~/Install

# Set up asdf (meta-package manager)
git clone https://github.com/asdf-vm/asdf.git --branch v0.14.1
. ~/Install/asdf/asdf.sh

for plug in $(get_list asdf); do
	asdf plugin add $plug
done


#!/bin/bash

#sudo apt-get install -y $(cat pkgs/apt.list | tr '\n' ' ')

mkdir ~/Install
for pkg in $(find $(pwd)/pkgs/custom -name \*\.sh); do
	cd ~/Install
	echo Installing $pkg
	. $pkg
done

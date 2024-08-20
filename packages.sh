#!/bin/bash

sudo apt-get install -y $(cat pkgs/apt.list | tr '\n' ' ')

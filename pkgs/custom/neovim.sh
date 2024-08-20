#!/bin/bash

# TODO: checksum

wget "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"

tar xzvf nvim-linux64.tar.gz nvim
rm nvim-linux64.tar.gz
ln nvim/bin/nvim .local/bin/nvim

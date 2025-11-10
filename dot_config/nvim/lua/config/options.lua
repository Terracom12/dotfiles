-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Tab = 4 spaces
vim.opt.tabstop = 4
vim.o.expandtab = true -- convert tabs into spaces
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.g.trouble_lualine = false

vim.g.autoformat = true -- disable autoformat

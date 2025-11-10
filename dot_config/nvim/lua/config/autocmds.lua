-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(args)
    local filepath = args.file

    -- Verify with chezmoi
    local target = vim.fn.system({'chezmoi', 'target-path', filepath})

    if vim.v.shell_error == 0 then
      local out = vim.fn.system({'chezmoi', 'apply', '--source-path', filepath})
      local msg = "[chezmoi] applied " .. target
      if vim.v.shell_error ~= 0 then
        msg = "[chezmoi] error: " .. out
      end
      -- schedule so message shows even if <Cmd>w> is used
      vim.schedule(function()
        vim.api.nvim_echo({{msg, "MoreMsg"}}, false, {})
      end)
    end
  end,
})

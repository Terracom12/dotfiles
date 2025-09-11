return {
    "neovim/nvim-lspconfig",
    opts = {
        autoformat = true,
        servers = {
            clangd = {},
            basedpyright = {
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "standard",
                        },
                    },
                },
            },
        },
        codelens = {
            enabled = false,
        },
        setup = {},
    },
    keys = {
        {
            "<leader>ci",
            function()
                local line = vim.api.nvim_get_current_line()
                local pos = vim.api.nvim_win_get_cursor(0)

                if line:find(";") then
                    vim.api.nvim_feedkeys("f;cl{}", "x", true)
                elseif not line:find("}") then
                    return
                end

                -- Set cursor back to original position (presumably on function name)
                vim.api.nvim_win_set_cursor(0, pos)
                -- Return to normal mode (from insert if cl{} left us there)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)

                vim.defer_fn(function()
                    vim.lsp.buf.code_action({
                        filter = function(action)
                            return action.title and action.title == "Move function body to out-of-line"
                        end,
                        apply = true,
                    })
                end, 100)
            end,
            desc = "Create function implementation out-of-line",
        },
        {
            "<leader>co",
            function()
                local bufnr = vim.api.nvim_get_current_buf()
                local method_name = "textDocument/switchSourceHeader"
                local client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
                if not client then
                    return vim.notify(
                        ("method %s is not supported by any servers active on the current buffer"):format(method_name)
                    )
                end
                local params = vim.lsp.util.make_text_document_params(bufnr)
                client.request(method_name, params, function(err, result)
                    if err then
                        error(tostring(err))
                    end
                    if not result then
                        vim.notify("corresponding file cannot be determined")
                        return
                    end
                    vim.cmd.edit(vim.uri_to_fname(result))
                end, bufnr)
            end,
        },
    },
}

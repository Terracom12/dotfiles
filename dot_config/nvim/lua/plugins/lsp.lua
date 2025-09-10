return {
    {
        "neovim/nvim-lspconfig",

        version = "^1.0.0",

        opts = {
            servers = {
                basedpyright = {
                    settings = {
                        basedpyright = { analysis = { typeCheckingMode = "standard" } },
                    },
                },
            },
        },
    },

    {
        "mason-org/mason-lspconfig.nvim",

        version = "^1.0.0",

        opts = {
            ensure_installed = {
                -- list of language servers to install by default
                "lua_ls",
                "clangd",
                "basedpyright",
                "bashls",
            },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
}

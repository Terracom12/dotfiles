return {
    -- Bufferline: Fancy file tabs with icons
    -- Modify to disable 'x' button
    {
        "akinsho/bufferline.nvim",
        opts = {
            options = {
                -- TODO: this is not working as I want; there's a blank space where 'x' would be
                -- show_buffer_close_icons = false,
                -- buffer_close_icon = '',
                -- close_icon = ''
            }
        },
    },

    -- Snacks: UI library & lots of QoL utils
    -- Lazygit looks bad nested, and there's no good reason to use it here anyways
    -- TODO: Theming sucks in all areas. No transparency!
    {
        "folke/snacks.nvim",
        opts = {
            lazygit = {},
        },
    }
}

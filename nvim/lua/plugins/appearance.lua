return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = { "italic" },
                    functions = { "italic" },
                    keywords = { "bold" },
                },
                default_integrations = true,
                integrations = {
                    gitsigns = true,
                    treesitter = true,
                    blink_cmp = true,
                    diffview = true,
                    nvim_surround = true,
                },
            })
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine"
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        init = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "kanagawa",
                callback = function()
                    vim.api.nvim_set_hl(0, "StatusLine", { link = "lualine_c_normal" })
                end,
            })
        end,
        opts = {
            colors = { theme = { all = { ui = { bg_gutter = "none" } } } }
        },
    }
}

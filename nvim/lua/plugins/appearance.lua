return {
    "rose-pine/neovim",
    enabled = false,
    name = "rose-pine",
    lazy = false,
    opts = {
        styles = { transparency = false }
    },
    {
        "catppuccin/nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
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
            colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
            transparent = true
        },
    },
    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        cmd = { "NoNeckPain" },
        keys = { { "<leader>|", "<cmd>NoNeckPain<cr>" } }
    }
}

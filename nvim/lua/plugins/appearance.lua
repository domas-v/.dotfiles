return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                integrations = {
                    notify = true,
                    nvimtree = true,
                    telescope = true,
                    cmp = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "bold" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                        }
                    },
                    dap = {
                        enabled = true,
                        enable_ui = true,
                    },
                    mason = true,
                    lsp_trouble = true,
                    symbols_outline = true,
                    treesitter = true,
                    neogit = true,
                    gitsigns = true,
                    barbar = true,
                    leap = true,
                    illuminate = true,
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = false,
                    },
                    markdown = true,
                    headlines = true
                }
            })
        end,
    },
    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true
    }
}

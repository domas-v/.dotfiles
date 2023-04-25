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
                    gitsigns = true,
                    illuminate = true,
                    barbar = true,
                    leap = true,
                    lsp_trouble = true,
                    symbols_outline = true,
                    treesitter = true,
                    neogit = true,
                    mason = true,
                    markdown = true,
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = false,
                    },
                }
            })
        end,
    },
    -- {
    --     "cormacrelf/dark-notify",
    --     config = function()
    --         require("dark_notify").run({
    --             schemes = {
    --                 dark  = "catppuccin-mocha",
    --                 light = "catppuccin-frappe"
    --             }
    --         })
    --     end
    -- },
}

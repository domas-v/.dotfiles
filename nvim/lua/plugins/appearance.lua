return {
    {
        "catppuccin/nvim",
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
                    nvim_surround = true,
                },
                lsp_styles = {
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "bold" },
                        warnings = { "underline" },
                        information = { "standout" },
                        ok = { "reverse" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
            })
        end
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('kanagawa').setup({
                compile = false,
                undercurl = true,
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { bold = true },
                statementStyle = { bold = true },
                terminalColors = true,
                theme = "wave",
                background = {
                    dark = "wave",
                    light = "lotus",
                },
                colors = { theme = { all = { ui = { bg_gutter = "none" } } } }
            })
        end
    },
    -- setup must be called before loading
    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        config = function()
            vim.keymap.set("n", "<Space>|", "<cmd>NoNeckPain<cr>")
        end,
    }
}

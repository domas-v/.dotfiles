return {
    {
        "catppuccin/nvim",
        lazy = false,
        priority = 1000,
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                transparent_background = true,
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
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        config = function()
            vim.keymap.set("n", "<Space>|", "<cmd>NoNeckPain<cr>")
        end,
    }
}

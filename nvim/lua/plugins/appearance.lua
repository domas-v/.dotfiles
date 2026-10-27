return {
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
}

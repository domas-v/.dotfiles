return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                -- transparent = true,
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none"
                            }
                        }
                    }
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        TelescopeTitle = { fg = theme.ui.special, bold = true },
                        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                    }
                end,
            })
        end
    },
    {
        "f-person/auto-dark-mode.nvim",
        config = function()
            local auto_dark_mode = require('auto-dark-mode')

            auto_dark_mode.setup({
                update_interval = 1000,
                set_dark_mode = function()
                    vim.api.nvim_set_option('background', 'dark')
                    vim.cmd('colorscheme kanagawa')
                end,
                set_light_mode = function()
                    vim.api.nvim_set_option('background', 'light')
                    vim.cmd('colorscheme kanagawa-lotus')
                end,
            })
            auto_dark_mode.init()
        end
    }
}

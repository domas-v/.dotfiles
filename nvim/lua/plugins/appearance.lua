return {
    {
        "projekt0n/github-nvim-theme",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({
                options = {
                    transparent = true,
                    styles = {
                        comments = 'italic',
                        keywords = 'bold',
                        types = 'italic,bold',
                    }
                }
            })
        end
    }
    -- {
    --     "rebelot/kanagawa.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         transparent = true,
    --         colors = {
    --             theme = {
    --                 all = {
    --                     ui = {
    --                         bg_gutter = "none"
    --                     }
    --                 }
    --             }
    --         },
    --         overrides = function(colors)
    --             local theme = colors.theme
    --             return {
    --                 NormalFloat = { bg = "none" },
    --                 FloatBorder = { bg = "none" },
    --                 FloatTitle = { bg = "none" },
    --                 NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
    --
    --                 LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    --
    --                 TelescopeTitle = { fg = theme.ui.special, bold = true },
    --                 -- TelescopePromptNormal = { bg = theme.ui.bg_p1 },
    --                 -- TelescopePreviewNormal = { bg = theme.ui.bg_dim },
    --                 TelescopePromptBorder = {
    --                     fg = theme.ui.bg_p1,
    --                     -- bg = theme.ui.bg_p1
    --                 },
    --                 TelescopeResultsNormal = {
    --                     fg = theme.ui.fg_dim,
    --                     -- bg = theme.ui.bg_m1
    --                 },
    --                 TelescopeResultsBorder = {
    --                     fg = theme.ui.bg_m1,
    --                     -- bg = theme.ui.bg_m1
    --                 },
    --                 TelescopePreviewBorder = {
    --                     fg = theme.ui.bg_dim
    --                     -- bg = theme.ui.bg_dim,
    --                 },
    --             }
    --         end,
    --
    --     }
    -- },
}

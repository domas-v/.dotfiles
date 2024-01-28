return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
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
                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },
                    NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                    LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                    TelescopeTitle = { fg = theme.ui.special, bold = true },
                    -- TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                    -- TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                    TelescopePromptBorder = {
                        fg = theme.ui.bg_p1,
                        -- bg = theme.ui.bg_p1
                    },
                    TelescopeResultsNormal = {
                        fg = theme.ui.fg_dim,
                        -- bg = theme.ui.bg_m1
                    },
                    TelescopeResultsBorder = {
                        fg = theme.ui.bg_m1,
                        -- bg = theme.ui.bg_m1
                    },
                    TelescopePreviewBorder = {
                        fg = theme.ui.bg_dim
                        -- bg = theme.ui.bg_dim,
                    },
                }
            end,

        }
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            styles = {
                comments = { italic = true, },
                keywords = { italic = true, bold = true },
                functions = { italic = true },
            },
            on_highlights = function(hl, c)
                local prompt = "#2d3149"
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePromptNormal = {
                    bg = prompt,
                }
                hl.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePromptTitle = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                } 
            end,
        }
    }

}

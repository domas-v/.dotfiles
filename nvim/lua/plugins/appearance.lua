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
    },
    {
        "rose-pine/neovim",
        lazy = false,
            config = function()
                require("rose-pine").setup({
                    variant = "auto", -- auto, main, moon, or dawn
                    dark_variant = "moon", -- main, moon, or dawn
                    dim_inactive_windows = false,
                    extend_background_behind_borders = true,
                    enable = {
                        terminal = true,
                        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                        migrations = true, -- Handle deprecated options automatically
                    },

                    styles = {
                        bold = true,
                        italic = true,
                        transparency = true,
                        undercurls = true
                    },

                    groups = {
                        border = "muted",
                        link = "iris",
                        panel = "surface",

                        error = "love",
                        hint = "iris",
                        info = "foam",
                        note = "pine",
                        todo = "rose",
                        warn = "gold",

                        git_add = "foam",
                        git_change = "rose",
                        git_delete = "love",
                        git_dirty = "rose",
                        git_ignore = "muted",
                        git_merge = "iris",
                        git_rename = "pine",
                        git_stage = "iris",
                        git_text = "rose",
                        git_untracked = "subtle",

                        h1 = "iris",
                        h2 = "foam",
                        h3 = "rose",
                        h4 = "gold",
                        h5 = "pine",
                        h6 = "foam",
                    }
                })
            end
    }
}

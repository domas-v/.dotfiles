return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
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
        "catppuccin/nvim",
        name = "catppuccin",
        config =
            function()
                local telescopeBorderless = function(flavor)
                    local cp = require("catppuccin.palettes").get_palette(flavor)
                    return {
                        TelescopeBorder = { fg = cp.surface0, bg = cp.surface0 },
                        TelescopeSelectionCaret = { fg = cp.flamingo, bg = cp.surface1 },
                        TelescopeMatching = { fg = cp.peach },
                        TelescopeNormal = { bg = cp.surface0 },
                        TelescopeSelection = { fg = cp.text, bg = cp.surface1 },
                        TelescopeMultiSelection = { fg = cp.text, bg = cp.surface2 },
                        TelescopeTitle = { fg = cp.crust, bg = cp.green },
                        TelescopePreviewTitle = { fg = cp.crust, bg = cp.red },
                        TelescopePromptTitle = { fg = cp.crust, bg = cp.mauve },
                        TelescopePromptNormal = { fg = cp.flamingo, bg = cp.crust },
                        TelescopePromptBorder = { fg = cp.crust, bg = cp.crust },
                    }
                end
                require("catppuccin").setup({
                    highlight_overrides = {
                        latte = telescopeBorderless('latte'),
                        frappe = telescopeBorderless('frappe'),
                        macchiato = telescopeBorderless('macchiato'),
                        mocha = telescopeBorderless('mocha'),
                    },
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
                    vim.cmd('colorscheme catppuccin-latte')
                end,
            })
            auto_dark_mode.init()
        end
    }
}

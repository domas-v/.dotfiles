return {
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
        config = function ()
            local auto_dark_mode = require('auto-dark-mode')

            auto_dark_mode.setup({
                update_interval = 1000,
                set_dark_mode = function()
                    vim.api.nvim_set_option('background', 'dark')
                    vim.cmd('colorscheme catppuccin-frappe')
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

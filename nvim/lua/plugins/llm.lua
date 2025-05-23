return {
    {
        "olimorris/codecompanion.nvim",
        opts = {
            strategies = {
                chat = {
                    adapter = "anthropic",
                },
                inline = {
                    adapter = "anthropic",
                },
            }
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        'milanglacier/minuet-ai.nvim',
        config = function()
            require('minuet').setup {
                provider = "claude",
                throttle = 200,
                debounce = 100,
                virtualtext = {
                    auto_trigger_ft = {},
                    keymap = {
                        accept = '<C-e>',
                        accept_line = '<A-l>',
                        -- accept_n_lines = '<C-e>',
                        prev = '<A-[>',
                        next = '<A-]>',
                        dismiss = '<A-k>',
                    },
                }
            }
        end,
    },
}

return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        build = "make",
        version = false,
        opts = {
            providers = {
                {
                    name = "Claude",
                    provider = "claude",
                    model = "claude-3-7-sonnet-20240229",
                },
                -- {
                --     name = "Claude Haiku",
                --     provider = "claude",
                --     model = "claude-3-haiku-20240307",
                -- },
            },
            default_provider = "Claude",
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            {
                "zbirenbaum/copilot.lua",
                cmd = "Copilot",
                opts = {
                    model = "claude-3-7-sonnet-20240229",
                    suggestion = {
                        enabled = true,
                        auto_trigger = true,
                        debounce = 75,
                        keymap = {
                            accept = "<Tab>",
                            accept_word = false,
                            accept_line = false,
                            next = "<M-]>",
                            prev = "<M-[>",
                            dismiss = "<C-]>",
                        },
                    },
                    panel = { enabled = false },
                },
            },
        },
    }
}

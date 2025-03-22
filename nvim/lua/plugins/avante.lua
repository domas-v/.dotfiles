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
                {
                    name = "Claude Haiku",
                    provider = "claude",
                    model = "claude-3-haiku-20240307",
                },
            },
            default_provider = "Claude",
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- Optional dependencies
            {
                "zbirenbaum/copilot.lua",
                event = "InsertEnter",
                opts = {
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
            {
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                    },
                },
            },
        },
    }
}

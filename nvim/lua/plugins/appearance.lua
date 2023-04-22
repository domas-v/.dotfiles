return {
    { "catppuccin/nvim", name = "catppuccin" },
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
                }
            })
        end
    },
    {
        "cormacrelf/dark-notify",
        config = function()
            require("dark_notify").run({
                schemes = {
                    dark  = "kanagawa-wave",
                    light = "catppuccin-latte"
                }
            })
        end
    },
    {
        'lukas-reineke/headlines.nvim',
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true
    }
}

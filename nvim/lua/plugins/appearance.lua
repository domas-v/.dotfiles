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
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "night",
            })
        end
    },
    {
        "cormacrelf/dark-notify",
        config = function()
            require("dark_notify").run({
                schemes = {
                    dark  = "tokyonight-night",
                    light = "tokyonight-day"
                }
            })
        end
    },
    -- {
    --     'lukas-reineke/headlines.nvim',
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     config = true
    -- }
}

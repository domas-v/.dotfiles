return {
    {
        "catppuccin/nvim",
        name = "catppuccin"
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
                    dark  = "catppuccin-mocha",
                    light = "catppuccin-frappe"
                }
            })
        end
    },
}

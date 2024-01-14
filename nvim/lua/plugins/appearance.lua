return {
    {
         "catppuccin/nvim",
         name = "catppuccin",
         opts = { transparent_background = true }
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                functions = { italic = true },
                variables = { italic = true }, 
            },
        }
    }

}

return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                transparent = true,
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
        "Shatur/neovim-ayu",
    }
}

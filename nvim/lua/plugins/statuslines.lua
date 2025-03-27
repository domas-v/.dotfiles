return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                globalstatus = true,
            },
            show_filename_only = false,
            sections = {
                lualine_x = { 'filetype' }
            }
        }
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    },
    {
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        keys = {
            { "<leader>>", "<cmd>Outline<CR>", desc = "Toggle outline" },
        },
        opts = {},
    },
}

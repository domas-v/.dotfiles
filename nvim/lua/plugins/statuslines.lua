return {
    -- {
    --     'nvim-lualine/lualine.nvim',
    --     enabled = false,
    --     dependencies = 'nvim-tree/nvim-web-devicons',
    --     opts = {
    --         options = {
    --             globalstatus = true,
    --         },
    --         show_filename_only = false,
    --         sections = {
    --             lualine_x = { 'filetype' }
    --         }
    --     }
    -- },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    }
}

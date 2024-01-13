return {
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end,
        event = "InsertEnter",
    },
    {
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup({ move_cursor = false }) end,
        event = "InsertEnter",
    },
    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    },
    {
        "ggandor/leap.nvim",
        config = function() require("leap").add_default_mappings() end,
        dependencies = "tpope/vim-repeat",
    },
    {
        "ggandor/flit.nvim",
        config = function() require("flit").setup() end
    },
    
    {
        "mg979/vim-visual-multi",
        init = function()
            vim.g.VM_maps = {
                ["Find Under"] = "<C-a>"
            }
        end,
        lazy = false,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                scope = { enabled = true },
            })
        end
    },
    "RRethy/vim-illuminate",
}

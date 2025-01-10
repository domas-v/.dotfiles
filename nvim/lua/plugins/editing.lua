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
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = { modes = { search = { enabled = false } } },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,                                       desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,                                 desc = "Flash Treesitter" },
            { "W", mode = { "n", "x", "o" }, function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end, desc = "Flash Treesitter" },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                scope = { enabled = false },
            })
        end
    },
    {
        "vladdoster/remember.nvim", -- remembers where in file I was
        config = function()
            require('remember')
        end
    }
}

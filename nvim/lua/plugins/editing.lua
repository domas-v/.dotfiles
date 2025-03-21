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
        "vladdoster/remember.nvim", -- remembers where in file I was
        config = function()
            require('remember')
        end
    },
    {
        "brenton-leighton/multiple-cursors.nvim",
        version = "*",
        opts = {},
        keys = {
            { "<c-s-j>",       "<cmd>MultipleCursorsAddDown<cr>",          mode = { "n", "x" }, desc = "add cursor and move down" },
            { "<c-s-k>",       "<cmd>MultipleCursorsAddUp<cr>",            mode = { "n", "x" }, desc = "add cursor and move up" },
            { "<c-leftmouse>", "<cmd>MultipleCursorsMouseAddDelete<cr>",   mode = { "n", "i" }, desc = "add or remove cursor" },
            { "<leader>m",     "<cmd>MultipleCursorsAddJumpNextMatch<cr>", mode = { "n", "x" }, desc = "add cursor and jump to next cword" },
            { "<leader>M",     "<cmd>MultipleCursorsAddMatches<cr>",       mode = { "n", "x" }, desc = "add cursors to cword" },
            { "<leader>L",     "<cmd>MultipleCursorsLock<cr>",             mode = { "n", "x" }, desc = "lock virtual cursors" },
        },
    },
}

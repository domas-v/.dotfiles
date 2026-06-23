return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = { labels = "qwertasdfgzxcvb", },
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
            { "<enter>",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "<c-s>", mode = { "i" },           function() require("flash").jump() end,       desc = "Flash (ins mode)" },
        },
    },
    {
        "nvim-mini/mini.pairs",
        version = false,
        opts = {}
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {},
    },
    {
        "nvim-mini/mini.comment",
        version = false,
        opts = {},
    },
    {
        "nvim-mini/mini.cursorword",
        version = false,
        opts = {},
    },
    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        config = function()
            vim.keymap.set("n", "<Space>|", "<cmd>NoNeckPain<cr>")
        end,
    },
}

return {
    {
        enabled = false,
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

        "justinmk/vim-sneak",
        init = function()
            vim.g["sneak#label"] = 0
            vim.g["sneak#use_ic_scs"] = 1
        end,
        config = function()
            vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>Sneak_s")
            vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>Sneak_S")

            vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>Sneak_f")
            vim.keymap.set({ "n", "x", "o" }, "F", "<Plug>Sneak_F")

            vim.keymap.set({ "n", "x", "o" }, "t", "<Plug>Sneak_t")
            vim.keymap.set({ "n", "x", "o" }, "T", "<Plug>Sneak_T")
        end,

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

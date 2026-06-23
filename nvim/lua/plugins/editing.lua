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
        "justinmk/vim-sneak",
        enabled = false,
        lazy = false,
        init = function()
            vim.g["sneak#label"] = 1
            vim.g["sneak#s_next"] = 1
            vim.g["sneak#use_ic_scs"] = 1
        end,
        config = function()
            vim.api.nvim_set_hl(0, "Sneak", { link = "IncSearch" })

            vim.keymap.set("n", "f", "<Plug>Sneak_f", { noremap = true })
            vim.keymap.set("n", "F", "<Plug>Sneak_F", { noremap = true })
            vim.keymap.set("n", "t", "<Plug>Sneak_t", { noremap = true })
            vim.keymap.set("n", "T", "<Plug>Sneak_T", { noremap = true })
        end
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

return {
    {
        enabled = false,
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = { labels = "qwertasdfgzxcvb", },
        keys = {
            { "s",       mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
            { "<enter>", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "<c-s>",   mode = { "i" },           function() require("flash").jump() end,       desc = "Flash (ins mode)" },
        },
    },
    {

        "justinmk/vim-sneak",
        init = function()
            vim.g["sneak#label"] = 0
            vim.g["sneak#use_ic_scs"] = 1
            vim.g["sneak#s_next"] = 1
        end,
        config = function()
            vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>Sneak_s")
            vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>Sneak_S")

            vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>Sneak_f")
            vim.keymap.set({ "n", "x", "o" }, "F", "<Plug>Sneak_F")

            vim.keymap.set({ "n", "x", "o" }, "t", "<Plug>Sneak_t")
            vim.keymap.set({ "n", "x", "o" }, "T", "<Plug>Sneak_T")

            vim.api.nvim_set_hl(0, "Sneak", { link = "IncSearch" })
            vim.api.nvim_set_hl(0, "SneakCurrent", { link = "CurSearch" })
            vim.api.nvim_set_hl(0, "SneakScope", { link = "Visual" })
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
        "ya2s/nvim-cursorline",
        opts = {
            disable_filetypes = {
                "snacks_picker_input",
                "snacks_picker_list",
                "snacks_picker_preview",
                "snacks_dashboard",
            },
            disable_buftypes = { "nofile", "prompt", "quickfix", "terminal" },
            cursorline = {
                enable = false,
                timeout = 0,
            },
            cursorword = {
                enable = true,
                min_length = 3,
                hl = { underline = true },
            }

        }
    },
    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        config = function()
            vim.keymap.set("n", "<Space>|", "<cmd>NoNeckPain<cr>")
        end,
    },
}

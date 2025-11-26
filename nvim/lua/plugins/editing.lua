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
        "chrisgrieser/nvim-origami",
        event = "VeryLazy",
        version = "1.9",
        opts = { setupFoldKeymaps = false, },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
            require('ufo').setup({
                provider_selector = function(_, _, _)
                    return { 'treesitter', 'indent' }
                end,
                enable_get_fold_virt_text = true,
                open_fold_hl_timeout = 150,
                preview = {
                    win_config = {
                        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                        winhighlight = "Normal:Folded",
                        winblend = 0,
                    },
                    mappings = {
                        jumpTop = "[",
                        jumpBot = "]",
                    },
                },
            })
        end
    },
}

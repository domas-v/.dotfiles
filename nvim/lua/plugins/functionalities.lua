return {
    {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
            }
        end
    },
    {
        "Pocco81/auto-save.nvim",
        config = function() require("auto-save").setup({ execution_message = { message = "" } }) end,
    },
    {
        'mrjones2014/smart-splits.nvim',
        build = './kitty/install-kittens.bash', -- works with kitty
        config = function() require('smart-splits').setup({
            default_amount = 15,
            at_edge = 'stop', -- default is wrap, but doesn't work in kitty
            resize_mode = { silent = true }})
        end,
        keys = {
            { "<C-h>", "<cmd>lua require('smart-splits').move_cursor_left()<cr>", "Move left" },
            { "<C-j>", "<cmd>lua require('smart-splits').move_cursor_down()<cr>", "Move bottom" },
            { "<C-k>", "<cmd>lua require('smart-splits').move_cursor_up()<cr>", "Move top" },
            { "<C-l>", "<cmd>lua require('smart-splits').move_cursor_right()<cr>", "Move right" },

            { "<A-h>", "<cmd>lua require('smart-splits').resize_left()<cr>", "Resize left" },
            { "<A-j>", "<cmd>lua require('smart-splits').resize_down()<cr>", "Resize bottom" },
            { "<A-k>", "<cmd>lua require('smart-splits').resize_up()<cr>", "Resize top" },
            { "<A-l>", "<cmd>lua require('smart-splits').resize_right()<cr>", "Resize right" },

            { "<C-w>r", "<cmd>lua require('smart-splits').start_resize_mode()<cr>", "Start resize mode" },
            { "<C-w><C-r>", "<cmd>lua require('smart-splits').start_resize_mode()<cr>", "Start resize mode" },
        }
    },
    {
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_target = "kitty"
        end,
        keys = {
            { "<C-c><C-e>", "<cmd>%SlimeSend<cr>", "Slime send file" },
            { "<C-c><C-c>", "<cmd>%SlimeSendCurrentLine<cr>", "Slime send current line" },
        }
    }
}

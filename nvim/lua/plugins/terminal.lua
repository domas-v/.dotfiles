return {
    {
        'mrjones2014/smart-splits.nvim',
        build = './kitty/install-kittens.bash', -- works with kitty
        config = function() require('smart-splits').setup({
            default_amount = 8,
            at_edge = 'stop', -- default is wrap, but doesn't work in kitty
            resize_mode = { silent = true }})
        end,
        keys = {
            { "<C-h>", "<cmd>lua require('smart-splits').move_cursor_left()<cr>", "Move left" },
            { "<C-j>", "<cmd>lua require('smart-splits').move_cursor_down()<cr>", "Move bottom" },
            { "<C-k>", "<cmd>lua require('smart-splits').move_cursor_up()<cr>", "Move top" },
            { "<C-l>", "<cmd>lua require('smart-splits').move_cursor_right()<cr>", "Move right" },

            -- { "<A-h>", "<cmd>lua require('smart-splits').resize_left()<cr>", "Resize left" },
            -- { "<A-j>", "<cmd>lua require('smart-splits').resize_down()<cr>", "Resize bottom" },
            -- { "<A-k>", "<cmd>lua require('smart-splits').resize_up()<cr>", "Resize top" },
            -- { "<A-l>", "<cmd>lua require('smart-splits').resize_right()<cr>", "Resize right" },

            { "<leader>wr", "<cmd>lua require('smart-splits').start_resize_mode()<cr>", "Start resize mode" },
        }
    },
}

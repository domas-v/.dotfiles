return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        end
    },
    -- {
    --     "Pocco81/auto-save.nvim",
    --     config = function()
    --         require("auto-save").setup({
    --             enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
    --             execution_message = {
    --                 message = function() -- message to print on save
    --                     return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
    --                 end,
    --                 dim = 0.18, -- dim the color of `message`
    --                 cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
    --             },
    --             trigger_events = {"InsertLeave", "TextChanged"},
    --             condition = function(buf)
    --                 if vim.bo[buf].filetype == "harpoon" then
    --                     return false
    --                 end
    --                 local fn = vim.fn
    --                 local utils = require("auto-save.utils.data")
    --
    --                 if
    --                     fn.getbufvar(buf, "&modifiable") == 1 and
    --                     utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
    --                     return true -- met condition(s), can save
    --                 end
    --                 return false
    --             end,
    --             write_all_buffers = false,
    --             debounce_delay = 135,
    --             callbacks = { -- functions to be executed at different intervals
    --             enabling = nil, -- ran when enabling auto-save
    --             disabling = nil, -- ran when disabling auto-save
    --             before_asserting_save = nil, -- ran before checking `condition`
    --             before_saving = nil, -- ran before doing the actual save
    --             after_saving = nil -- ran after doing the actual save
    --         }
    --     })
    --     end,
    -- },
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

            { "<A-h>", "<cmd>lua require('smart-splits').resize_left()<cr>", "Resize left" },
            { "<A-j>", "<cmd>lua require('smart-splits').resize_down()<cr>", "Resize bottom" },
            { "<A-k>", "<cmd>lua require('smart-splits').resize_up()<cr>", "Resize top" },
            { "<A-l>", "<cmd>lua require('smart-splits').resize_right()<cr>", "Resize right" },

            { "<C-w><C-r>", "<cmd>lua require('smart-splits').start_resize_mode()<cr>", "Start resize mode" },
            { "<leader>wr", "<cmd>lua require('smart-splits').start_resize_mode()<cr>", "Start resize mode" },
        }
    },
    {
        'sindrets/winshift.nvim',
        config = function() require('winshift').setup() end,
        keys = {
            { "<C-w><C-m>", "<cmd>WinShift<cr>",       desc = "WinShift mode" },
            { "<C-w><C-h>", "<cmd>WinShift left<cr>",  desc = "Winshift left" },
            { "<C-w><C-k>", "<cmd>WinShift up<cr>",    desc = "WinShift up" },
            { "<C-w><C-j>", "<cmd>WinShift down<cr>",  desc = "WinShift down" },
            { "<C-w><C-l>", "<cmd>WinShift right<cr>", desc = "WinShift right" },

            { "<leader>wm", "<cmd>WinShift<cr>",       desc = "WinShift mode" },
            { "<leader>wh", "<cmd>WinShift left<cr>",  desc = "Winshift left" },
            { "<leader>wk", "<cmd>WinShift up<cr>",    desc = "WinShift up" },
            { "<leader>wj", "<cmd>WinShift down<cr>",  desc = "WinShift down" },
            { "<leader>wl", "<cmd>WinShift right<cr>", desc = "WinShift right" },
        }
    },
}

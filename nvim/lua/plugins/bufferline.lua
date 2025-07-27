return {
    {
        'akinsho/bufferline.nvim',
        lazy = false,
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            local bufferline = require('bufferline')
            bufferline.setup({
                options = {
                    style_preset = bufferline.style_preset.minimal,
                    numbers = "none",
                    themable = false,
                }
            }
            )
        end,
        keys = {
            { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>" },
            { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>" },
            { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>" },
            { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>" },
            { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>" },
            { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>" },
            { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>" },
            { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>" },
            { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>" },
            { "<leader>0", "<cmd>BufferLineGoToBuffer 9<cr>" },
            { "<leader>n", "<cmd>BufferLineCycleNext<cr>" },
            { "<leader>p", "<cmd>BufferLineCyclePrev<cr>" },
            { "<leader>]", "<cmd>BufferLineMoveNext<cr>" },
            { "<leader>[", "<cmd>BufferLineMovePrev<cr>" },
            { "<leader>*", "<cmd>BufferLineTogglePin<cr>" },

            { "<C-1>",     "<cmd>BufferLineGoToBuffer 1<cr>" },
            { "<C-2>",     "<cmd>BufferLineGoToBuffer 2<cr>" },
            { "<C-3>",     "<cmd>BufferLineGoToBuffer 3<cr>" },
            { "<C-4>",     "<cmd>BufferLineGoToBuffer 4<cr>" },
            { "<C-5>",     "<cmd>BufferLineGoToBuffer 5<cr>" },
            { "<C-6>",     "<cmd>BufferLineGoToBuffer 6<cr>" },
            { "<C-7>",     "<cmd>BufferLineGoToBuffer 7<cr>" },
            { "<C-8>",     "<cmd>BufferLineGoToBuffer 8<cr>" },
            { "<C-9>",     "<cmd>BufferLineGoToBuffer 9<cr>" },
            { "<C-0>",     "<cmd>BufferLineGoToBuffer 9<cr>" },
            { "<C-n>",     "<cmd>BufferLineCycleNext<cr>" },
            { "<C-p>",     "<cmd>BufferLineCyclePrev<cr>" },
            { "<C-]>",     "<cmd>BufferLineMoveNext<cr>" },
            { "<C-[>",     "<cmd>BufferLineMovePrev<cr>" },
            { "<C-*>",     "<cmd>BufferLineTogglePin<cr>" },
            { "<C-t>",     "<cmd>BufferLinePick<cr>" },
        }
    },
    {
        'sindrets/winshift.nvim',
        config = function() require('winshift').setup() end,
        cmd = { "WinShift" },
        keys = {
            { "<leader>wm", "<cmd>WinShift<cr>",       desc = "WinShift mode" },
            { "<leader>wh", "<cmd>WinShift left<cr>",  desc = "Winshift left" },
            { "<leader>wk", "<cmd>WinShift up<cr>",    desc = "WinShift up" },
            { "<leader>wj", "<cmd>WinShift down<cr>",  desc = "WinShift down" },
            { "<leader>wl", "<cmd>WinShift right<cr>", desc = "WinShift right" },
        }
    },
    {
        "kevinhwang91/nvim-bqf",
        ft = 'qf',
        dependencies = {
            'junegunn/fzf',
            config = function() vim.fn['fzf#install']() end
        }
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            { "<leader>T", "<cmd>TodoQuickFix<cr>", desc = "TodoQuickfix" },
        }
    }
}

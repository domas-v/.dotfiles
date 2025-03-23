return {
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
        'nvim-lualine/lualine.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('lualine').setup({
                options = {
                    globalstatus = true,
                    theme = "catppuccin"
                },
                show_filename_only = false,
                sections = {
                    lualine_x = { 'filetype' }
                }
            })
        end,
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    },
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        dependencies = {
            'junegunn/fzf',
            config = function() vim.fn['fzf#install']() end
        }
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
    }
}

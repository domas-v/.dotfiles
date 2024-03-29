return {
    {
        "nvim-tree/nvim-tree.lua",
        cmd = "NvimTreeToggle",
        config = function() require('nvim-tree').setup() end,
        keys = {
            { "<leader><TAB>", "<cmd>NvimTreeToggle<cr>" },
        }
    },
    {
        'romgrk/barbar.nvim',
        lazy = false,
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("barbar").setup({
                animation = false,
                focus_on_close = 'previous',
                icons = {
                    button = 'Ｘ',
                    pinned = {button = ' ' , filename = true},
                },
            })
        end,
        keys = {
            { "<leader>*",  "<cmd>BufferPin<cr>" },
            { "<leader>b",  "<cmd>BufferPick<cr>" },
            { "<C-b>",  "<cmd>BufferPick<cr>" },

            { "<C-n>",      "<cmd>BufferNext<cr>" },
            { "<C-p>",      "<cmd>BufferPrevious<cr>" },
            { "<C-]>",      "<cmd>BufferMoveNext<cr>" },
            { "<C-[>",      "<cmd>BufferMovePrevious<cr>" },
            { "<leader>n",  "<cmd>BufferNext<cr>" },
            { "<leader>p",  "<cmd>BufferPrevious<cr>" },
            { "<leader>]",  "<cmd>BufferMoveNext<cr>" },
            { "<leader>[",  "<cmd>BufferMovePrevious<cr>" },

            { "<C-1>",  "<cmd>BufferGoto 1<cr>" },
            { "<C-1>",  "<cmd>BufferGoto 1<cr>" },
            { "<C-2>",  "<cmd>BufferGoto 2<cr>" },
            { "<C-3>",  "<cmd>BufferGoto 3<cr>" },
            { "<C-4>",  "<cmd>BufferGoto 4<cr>" },
            { "<C-5>",  "<cmd>BufferGoto 5<cr>" },
            { "<C-6>",  "<cmd>BufferGoto 6<cr>" },
            { "<C-7>",  "<cmd>BufferGoto 7<cr>" },
            { "<C-8>",  "<cmd>BufferGoto 8<cr>" },
            { "<C-9>",  "<cmd>BufferLast<cr>" },
            { "<leader>1",  "<cmd>BufferGoto 1<cr>" },
            { "<leader>2",  "<cmd>BufferGoto 2<cr>" },
            { "<leader>3",  "<cmd>BufferGoto 3<cr>" },
            { "<leader>4",  "<cmd>BufferGoto 4<cr>" },
            { "<leader>5",  "<cmd>BufferGoto 5<cr>" },
            { "<leader>6",  "<cmd>BufferGoto 6<cr>" },
            { "<leader>7",  "<cmd>BufferGoto 7<cr>" },
            { "<leader>8",  "<cmd>BufferGoto 8<cr>" },
            { "<leader>9",  "<cmd>BufferLast<cr>" },

            { "<C-x>",      "<cmd>BufferClose<cr>" },
            { "<leader>xx", "<cmd>BufferClose<cr>" },
            { "<leader>xo", "<cmd>BufferCloseAllButCurrent<cr>" },
            { "<leader>xh", "<cmd>BufferCloseBuffersLeft<cr>" },
            { "<leader>xl", "<cmd>BufferCloseBuffersRight<cr>" },
            { "<leader>xp", "<cmd>BufferPickDelete<cr>" },
        }
    },
    {
          'nvim-lualine/lualine.nvim',
          dependencies = 'nvim-tree/nvim-web-devicons' ,
          config = function()
              require('lualine').setup {
                  show_filename_only = false,
                  sections = {
                      lualine_x = {'filetype'}
                  }
              }
          end,
    },
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        dependencies = 'junegunn/fzf',
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup()
        end,
        keys = {
            { "<leader>ft", "<cmd>TodoTelescope<cr>" }
        }
    },
    {
        "DanilaMihailov/beacon.nvim" 
    }
}

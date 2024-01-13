return {
    {
        "nvim-tree/nvim-tree.lua",
        cmd = "NvimTreeToggle",
        config = function() require('nvim-tree').setup() end,
        keys = {
            { "<leader><TAB>", "<cmd>NvimTreeToggle<cr>" },
            { "<leader>tt", "<cmd>NvimTreeToggle<cr>" },
            { "<leader>tf", "<cmd>NvimTreeFindFile<cr>" },
            { "<leader>tc", "<cmd>NvimTreeCollapse<cr>" },
        }
    },
    {
        'romgrk/barbar.nvim',
        lazy = false,
        dependencies = 'kyazdani42/nvim-web-devicons',
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
            { "<leader>p",  "<cmd>BufferPick<cr>" },

            { "<C-n>",      "<cmd>BufferNext<cr>" },
            { "<C-p>",      "<cmd>BufferPrevious<cr>" },
            { "<C-]>",      "<cmd>BufferMoveNext<cr>" },
            { "<C-[>",      "<cmd>BufferMovePrevious<cr>" },

            { "<C-1>",      "<cmd>BufferGoto 1<cr>" },
            { "<C-2>",      "<cmd>BufferGoto 2<cr>" },
            { "<C-3>",      "<cmd>BufferGoto 3<cr>" },
            { "<C-4>",      "<cmd>BufferGoto 4<cr>" },
            { "<C-5>",      "<cmd>BufferGoto 5<cr>" },
            { "<C-6>",      "<cmd>BufferGoto 6<cr>" },
            { "<C-7>",      "<cmd>BufferGoto 7<cr>" },
            { "<C-8>",      "<cmd>BufferGoto 8<cr>" },
            { "<C-9>",      "<cmd>BufferLast<cr>" },
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
        'sindrets/winshift.nvim',
        config = function() require('winshift').setup() end,
        keys = {
            { "<leader>wm", "<cmd>WinShift<cr>",       desc = "WinShift mode" },
            { "<leader>wh", "<cmd>WinShift left<cr>",  desc = "Winshift left" },
            { "<leader>wk", "<cmd>WinShift up<cr>",    desc = "WinShift up" },
            { "<leader>wj", "<cmd>WinShift down<cr>",  desc = "WinShift down" },
            { "<leader>wl", "<cmd>WinShift right<cr>", desc = "WinShift right" },
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
    }
}

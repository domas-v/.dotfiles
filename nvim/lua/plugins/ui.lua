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
        "famiu/bufdelete.nvim",
        keys = {
            { "<C-x>", "<cmd>lua require('bufdelete').bufdelete(0)<cr>", desc = "Delete current buffer" },
        }
    },
    {
        "refractalize/oil-git-status.nvim",
        dependencies = {
            'stevearc/oil.nvim',
            dependencies = { "nvim-tree/nvim-web-devicons" },
            cmd = { "Oil" },
            opts = {
                win_options = {
                    signcolumn = "yes:2",
                },
                columns = {
                    "icon",
                    "permissions",
                    "size",
                    "mtime"
                },
                view_options = {
                    show_hidden = true
                },
                use_default_keymaps = false,
                keymaps = {
                    ["g?"] = { "actions.show_help", mode = "n" },
                    ["<CR>"] = "actions.select",
                    ["<C-v>"] = { "actions.select", opts = { vertical = true } },
                    ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
                    ["<C-t>"] = { "actions.select", opts = { tab = true } },
                    ["<leader>p"] = "actions.preview",
                    ["q"] = { "actions.close", mode = "n" },
                    ["<C-r>"] = "actions.refresh",
                    ["-"] = { "actions.parent", mode = "n" },
                    ["_"] = { "actions.open_cwd", mode = "n" },
                    ["`"] = { "actions.cd", mode = "n" },
                    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                    ["gs"] = { "actions.change_sort", mode = "n" },
                    ["gx"] = "actions.open_external",
                    ["g."] = { "actions.toggle_hidden", mode = "n" },
                    ["g\\"] = { "actions.toggle_trash", mode = "n" },
                },
            },
            keys = {
                { "<leader>.", "<cmd>Oil<cr>" },
                { "<leader>D", "<cmd>lua require('oil').open(vim.fn.getcwd())<cr>" }
            }
        },
        config = true,
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
            { "<leader>1",   "<cmd>BufferLineGoToBuffer 1<cr>" },
            { "<leader>2",   "<cmd>BufferLineGoToBuffer 2<cr>" },
            { "<leader>3",   "<cmd>BufferLineGoToBuffer 3<cr>" },
            { "<leader>4",   "<cmd>BufferLineGoToBuffer 4<cr>" },
            { "<leader>5",   "<cmd>BufferLineGoToBuffer 5<cr>" },
            { "<leader>6",   "<cmd>BufferLineGoToBuffer 6<cr>" },
            { "<leader>7",   "<cmd>BufferLineGoToBuffer 7<cr>" },
            { "<leader>8",   "<cmd>BufferLineGoToBuffer 8<cr>" },
            { "<leader>9",   "<cmd>BufferLineGoToBuffer 9<cr>" },
            { "<leader>0",   "<cmd>BufferLineGoToBuffer 9<cr>" },
            { "<C-n>",   "<cmd>BufferLineCycleNext<cr>" },
            { "<C-p>",   "<cmd>BufferLineCyclePrev<cr>" },
            { "<C-]>",   "<cmd>BufferLineMoveNext<cr>" },
            { "<C-[>",   "<cmd>BufferLineMovePrev<cr>" },
            { "<C-S-8>", "<cmd>BufferLineTogglePin<cr>" },
            { "<C-a>",   "<cmd>BufferLinePick<cr>" },
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
    { "RRethy/vim-illuminate", event = "VeryLazy" }
}

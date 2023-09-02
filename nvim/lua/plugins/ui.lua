return {
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    globalstatusline = true,
                    theme = "auto",
                    component_separators = { "", "" },
                    section_separators = { "", "" },
                    disabled_filetypes = {}
                },
                extensions = {
                    "quickfix",
                    "nvim-tree",
                    "nvim-dap-ui",
                    "symbols-outline",
                    "trouble" },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "filetype" },
                    lualine_z = { "location" }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = { "branch", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "filetype" },
                    lualine_z = { "location" }
                }
            }
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
        end,
        keys = {
            { "<leader><TAB>", "<cmd>Neotree<cr>",         desc = "Neotree" }
        }
    },
    {
        'folke/trouble.nvim',
        dependencies = 'kyazdani42/nvim-web-devicons',
        config = function() require('trouble').setup() end,
        keys = { { "<leader>dl", "<cmd>TroubleToggle<cr>", desc = "TroubleToggle" } }
    },
    {
        'folke/todo-comments.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require('todo-comments').setup({
                signs = false,
                keywords = {
                    FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                    TODO = { icon = " ", color = "info", alt = { "STYLE" } },
                    HACK = { icon = " ", color = "warning", alt = { "TEMP", "TEMPORARY" } },
                    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                },
            })
        end,
    },
    {
        'romgrk/barbar.nvim',
        lazy = false,
        dependencies = 'kyazdani42/nvim-web-devicons',
        opts = {
            icons = { pinned = { button = "📌" } },
            insert_at_end = true,
        },
        keys = {
            { "<leader>*",  "<cmd>BufferPin<cr>" },
            { "<leader>n",  "<cmd>BufferNext<cr>" },
            { "<leader>p",  "<cmd>BufferPrevious<cr>" },
            { "<leader>]",  "<cmd>BufferMoveNext<cr>" },
            { "<leader>[",  "<cmd>BufferMovePrevious<cr>" },
            { "<leader>1",  "<cmd>BufferGoto 1<cr>" },
            { "<leader>2",  "<cmd>BufferGoto 2<cr>" },
            { "<leader>3",  "<cmd>BufferGoto 3<cr>" },
            { "<leader>4",  "<cmd>BufferGoto 4<cr>" },
            { "<leader>5",  "<cmd>BufferGoto 5<cr>" },
            { "<leader>6",  "<cmd>BufferGoto 5<cr>" },
            { "<leader>7",  "<cmd>BufferGoto 5<cr>" },
            { "<leader>8",  "<cmd>BufferGoto 5<cr>" },
            { "<leader>9",  "<cmd>BufferLast<cr>" },
            { "<leader>xx", "<cmd>BufferClose<cr>" },
            { "<leader>xo", "<cmd>BufferCloseAllButCurrent<cr>" },
            { "<leader>xj", "<cmd>BufferCloseBuffersLeft<cr>" },
            { "<leader>xk", "<cmd>BufferCloseBuffersRight<cr>" },
            { "<leader>x*", "<cmd>BufferCloseAllButPinned<cr>" },
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
        'simeji/winresizer',
        keys = {
            { "<leader>wr", "<cmd>WinResizerStartResize<cr>", desc = "Win resize mode" }
        }
    },
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        dependencies = { 'junegunn/fzf', build = function() vim.fn['fzf#install']() end }
    },
}

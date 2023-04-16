return {
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require("nvim-tree").setup({
                view = { mappings = { list = { { key = "s", action = "" } } } } })
        end,
        keys = {
            { "<leader><", "<cmd>NvimTreeFindFileToggle<cr>", desc = "NvimTree" },
            { "<leader>,", "<cmd>NvimTreeFindFileToggle<cr>", desc = "NvimTree" },
        },
    },
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
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = { "filename" },
                    lualine_x = { "filetype" },
                    lualine_z = { "location" }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = { "branch" },
                    lualine_c = { "filename" },
                    lualine_x = { "filetype" },
                    lualine_z = { "location" }
                }
            }
        end
    },
    {
        'simrat39/symbols-outline.nvim',
        config = function() require('symbols-outline').setup() end,
        keys = {
            { "<leader>>", "<cmd>SymbolsOutline<cr>", desc = "SymbolsOutline" },
            { "<leader>.", "<cmd>SymbolsOutline<cr>", desc = "SymbolsOutline" },
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
        config = function() require('todo-comments').setup() end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('indent_blankline').setup({
                space_char_blankline = ' ',
                show_current_context = true,
                show_current_context_start = false,
                filetype_exclude = { 'startup' },
            })
        end
    },
    {
        'romgrk/barbar.nvim',
        lazy = false,
        dependencies = 'kyazdani42/nvim-web-devicons',
        opts = {
            icons = { pinned = { button = "車" } },
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
            { "<leader>0",  "<cmd>BufferLast<cr>" },
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
    {
        "folke/zen-mode.nvim",
        config = function() require("zen-mode").setup() end,
        keys = {
            { "<leader><leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" }
        }
    },
    {
        "folke/noice.nvim",
        config = function()
            require("noice").setup({
                messages = {
                    enabled = true
                },
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    bottom_search = true,
                    -- command_palette = false,
                    long_message_to_split = true,
                    inc_rename = true,
                    lsp_doc_border = true,
                },
                views = {
                    cmdline_popup = {
                        position = {
                            row = "45%",
                            col = "50%"
                        },
                    }
                }
            })
        end,
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }
    }
}

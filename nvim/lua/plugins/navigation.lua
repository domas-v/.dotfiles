return {
    -- WINDOW NAVIGATION
    {
        "kevinhwang91/nvim-bqf",
        ft = 'qf',
        dependencies = {
            'junegunn/fzf',
            config = function() vim.fn['fzf#install']() end
        }
    },
    {
        'sindrets/winshift.nvim',
        config = function() require('winshift').setup() end,
        cmd = { "WinShift" },
        keys = {
            { "<leader>m", "<cmd>WinShift<cr>", desc = "WinShift mode" },
        }
    },
    {
        "christoomey/vim-tmux-navigator",
        enabled = false,
        lazy = false,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    {
        "vladdoster/remember.nvim", -- remembers where in file I was
        config = function()
            require('remember')
        end
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
        "justinmk/vim-sneak",
        lazy = false,
        init = function()
            vim.g["sneak#label"] = 1
            vim.g["sneak#s_next"] = 1
        end,
        config = function()
            vim.api.nvim_set_hl(0, "Sneak", { link = "IncSearch" })

            vim.keymap.set('n', 'f', "<Plug>Sneak_f", { noremap = true })
            vim.keymap.set('n', 'F', "<Plug>Sneak_F", { noremap = true })
            vim.keymap.set('n', 't', "<Plug>Sneak_t", { noremap = true })
            vim.keymap.set('n', 'T', "<Plug>Sneak_T", { noremap = true })
        end
    },

    -- FOLDS
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
    },
}

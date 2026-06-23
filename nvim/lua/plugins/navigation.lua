return {
    -- WINDOW NAVIGATION
    {
        -- buffers per tab
        "aurora0x27/bpm.nvim",
        config = function()
            require("bpm").setup()
        end,
    },
    {
        -- quickfix
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
        "vladdoster/remember.nvim",
        config = function()
            require('remember')
        end
    },
    {
        -- breadcrumbs
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    },

    -- FOLDS
    {
        "chrisgrieser/nvim-origami",
        event = "VeryLazy",
        opts = {}, -- required even when using default config

        -- recommended: disable vim's auto-folding
        init = function()
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end,
    },
    -- {
    --     "kevinhwang91/nvim-ufo",
    --     dependencies = { "kevinhwang91/promise-async" },
    --     config = function()
    --         vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    --         vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    --         require('ufo').setup({
    --             provider_selector = function(_, _, _)
    --                 return { 'treesitter', 'indent' }
    --             end,
    --             enable_get_fold_virt_text = true,
    --             open_fold_hl_timeout = 150,
    --             preview = {
    --                 win_config = {
    --                     border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    --                     winhighlight = "Normal:Folded",
    --                     winblend = 0,
    --                 },
    --                 mappings = {
    --                     jumpTop = "[",
    --                     jumpBot = "]",
    --                 },
    --             },
    --         })
    --     end
    -- },
}

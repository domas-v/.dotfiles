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
            { "<leader>M", "<cmd>WinShift<cr>", desc = "WinShift mode" },
        }
    },
    {
        "christoomey/vim-tmux-navigator",
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
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)

            vim.keymap.set("n", "<C-s>", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<C-r>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-t>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-a>", function() harpoon:list():select(4) end)
        end,
    },

    -- WINDOW DECORATIONS
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

    -- TEXT NAVIGATION
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end,
        event = "InsertEnter",
    },
    {
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup({ move_cursor = false }) end,
        event = "InsertEnter",
    },
    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    },
    {
        -- sneak
        "ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
            vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
            vim.keymap.set({ 'x', 'o' }, 'R', function()
                require('leap.treesitter').select {
                    opts = require('leap.user').with_traversal_keys('R', 'r')
                }
            end)
            vim.keymap.set({ 'n', 'o' }, 'gs', function()
                require('leap.remote').action {
                    -- Automatically enter Visual mode when coming from Normal.
                    input = vim.fn.mode(true):match('o') and '' or 'v'
                }
            end)
        end,
    },
    {

        "chrisgrieser/nvim-origami",
        event = "VeryLazy",
        version = "1.9",
        opts = { setupFoldKeymaps = false, },
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
    },
}

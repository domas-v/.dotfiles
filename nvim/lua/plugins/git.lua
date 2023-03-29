return {
    {
        'TimUntersberger/neogit',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function ()
            require('neogit').setup({
                kind = "vsplit",
                integrations = {
                    diffview = true
                },
                disable_commit_confirmation = true
            })
        end,
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
        }
    },
    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        config = function () require('gitsigns').setup() end,
        keys = {
            { "<leader>gj", "<cmd>Gitsigns next_hunk<cr>", desc = "Gitsigns next" },
            { "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>", desc = "Gitsigns prev" },
            { "<leader>gv", "<cmd>Gitsigns preview_hunk<cr>", desc = "Gitsigns preview" },
            { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Gitsigns stage" },
            { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Gitsigns undo stage" },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Gitsigns reset" },

            -- toggles
            { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git blame" },
            { "<leader>gw", "<cmd>Gitsigns toggle_word_diff<cr>", desc = "Git diff words" },
            { "<leader>gd", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Git show deleted" },
        }
    },
    {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function () require"octo".setup() end,
        cmd = "Octo",
    }
}

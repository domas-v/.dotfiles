return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("neogit").setup({
                kind = "tab",
                commit_editor = {
                    kind = "vsplit",
                },
                disable_commit_confirmation = true
            })
        end,
        cmd = { "Neogit" },
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>",      desc = "Neogit" },
            { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Neogit" },
            { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Neogit" },
        }
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function()
            require('gitsigns').setup({
                current_line_blame_opts = { delay = 100 },
            })
        end,
        keys = {
            { "<leader>gj", "<cmd>Gitsigns next_hunk<cr>",                 desc = "Gitsigns next" },
            { "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>",                 desc = "Gitsigns prev" },
            { "<leader>gv", "<cmd>Gitsigns preview_hunk<cr>",              desc = "Gitsigns preview" },
            { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",                mode = { 'n', 'v' },            desc = "Gitsigns stage" },
            { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>",           desc = "Gitsigns undo stage" },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",                desc = "Gitsigns reset" },

            -- toggles
            { "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git blame current line" },
            { "<leader>gb", "<cmd>Gitsigns blame<cr>",                     desc = "Git blame file" },
            { "<leader>gw", "<cmd>Gitsigns toggle_word_diff<cr>",          desc = "Git diff words" },
            { "<leader>gd", "<cmd>Gitsigns toggle_deleted<cr>",            desc = "Git show deleted" },
        }
    },
    {
        "sindrets/diffview.nvim",
        enabled = false,
        config = function()
            require("diffview").setup({
                view = {
                    merge_tool = {
                        layout = "diff3_mixed"
                    }
                },
                file_panel = {
                    win_config = {
                        width = 25
                    }
                }
            })
        end
    },
    {
        'ruifm/gitlinker.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require "gitlinker".setup()
        end
    }
}

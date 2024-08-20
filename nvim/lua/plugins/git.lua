return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("neogit").setup({
                kind = "vsplit",
                commit_editor = {
                    kind = "split",
                },
                disable_commit_confirmation = true
            })
        end,
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
            { "<C-g><C-g>", "<cmd>Neogit<cr>", desc = "Neogit" },
        }
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function() require('gitsigns').setup() end,
        keys = {
            { "<leader>gj", "<cmd>Gitsigns next_hunk<cr>",                     desc = "Gitsigns next" },
            { "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>",                     desc = "Gitsigns prev" },
            { "<leader>gv", "<cmd>Gitsigns preview_hunk<cr>",                  desc = "Gitsigns preview" },
            { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", mode = {'n', 'v'}, desc = "Gitsigns stage" },
            { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>",               desc = "Gitsigns undo stage" },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",                    desc = "Gitsigns reset" },

            -- toggles
            { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>",     desc = "Git blame" },
            { "<leader>gw", "<cmd>Gitsigns toggle_word_diff<cr>",              desc = "Git diff words" },
            { "<leader>gd", "<cmd>Gitsigns toggle_deleted<cr>",                desc = "Git show deleted" },
        }
    },
    {
        "sindrets/diffview.nvim",
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
            require"gitlinker".setup()
        end
    }
}

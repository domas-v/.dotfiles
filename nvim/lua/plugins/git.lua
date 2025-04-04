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
                    show_staged_diff = false,
                },
                disable_commit_confirmation = true
            })
        end,
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>",        desc = "Open Neogit" },
            { "<leader>gp", "<cmd>Neogit pull<cr>",   desc = "Neogit pull" },
            { "<leader>gP", "<cmd>Neogit push<cr>",   desc = "Neogit push" },
            { "<leader>gm", "<cmd>Neogit merge<cr>",  desc = "Neogit merge" },
            { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
            { "<leader>gz", "<cmd>Neogit stash<cr>",  desc = "Neogit stash" },
            { "<leader>gb", "<cmd>Neogit branch<cr>", desc = "Neogit branch" },
        }
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function()
            require('gitsigns').setup({ current_line_blame_opts = { delay = 100 } })
        end,
        keys = {
            { "<leader>gj", "<cmd>Gitsigns next_hunk<cr>",                 desc = "Gitsigns next" },
            { "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>",                 desc = "Gitsigns prev" },
            { "<leader>gv", "<cmd>Gitsigns preview_hunk<cr>",              desc = "Gitsigns preview" },
            { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",                desc = "Gitsigns stage",        mode = { 'n', 'v' } },
            { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>",           desc = "Gitsigns undo stage" },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",                desc = "Gitsigns reset" },

            -- toggles
            { "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git blame current line" },
            { "<leader>gL", "<cmd>Gitsigns blame<cr>",                     desc = "Git blame file" },
            { "<leader>gW", "<cmd>Gitsigns toggle_word_diff<cr>",          desc = "Git diff words" },
            { "<leader>gD", "<cmd>Gitsigns toggle_deleted<cr>",            desc = "Git show deleted" },
        }
    }
}

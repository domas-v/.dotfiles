return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("neogit").setup({
                kind = "replace",
                commit_editor = {
                    kind = "vsplit",
                    staged_diff_split_kind = "split",
                },
                disable_commit_confirmation = true
            })

            vim.cmd('command G Neogit')
            vim.cmd('command Gp Neogit push')
            vim.cmd('command Gl Neogit pull')
            vim.cmd('command Gc Neogit commit')
            vim.cmd('command Gb Neogit branch')
            vim.cmd('command Gz Neogit stash')
        end,
        cmd = { "G", "Gp", "Gl", "Gc", "Gb", "Gz" },
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" }
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
            { "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>",                desc = "Gitsigns stage",        mode = { 'n', 'v' } },
            { "<leader>gx", "<cmd>Gitsigns undo_stage_hunk<cr>",           desc = "Gitsigns undo stage" },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",                desc = "Gitsigns reset" },

            -- toggles
            { "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git blame current line" },
            { "<leader>gL", "<cmd>Gitsigns blame<cr>",                     desc = "Git blame file" },
            { "<leader>gW", "<cmd>Gitsigns toggle_word_diff<cr>",          desc = "Git diff words" },
            { "<leader>gD", "<cmd>Gitsigns toggle_deleted<cr>",            desc = "Git show deleted" },
        }
    }
}

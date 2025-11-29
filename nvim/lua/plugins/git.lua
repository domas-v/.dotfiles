return {
    { "tpope/vim-fugitive" },
    {
        "NeogitOrg/neogit",
        enabled = false,
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
                disable_commit_confirmation = true,
                auto_close_console = false,
            })
        end,
        cmd = { "Neogit" },
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>",        desc = "Open Neogit" },
            { "<leader>gp", "<cmd>Neogit pull<cr>",   desc = "Neogit pull" },
            { "<leader>gP", "<cmd>Neogit push<cr>",   desc = "Neogit push" },
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
            { "]g", "<cmd>Gitsigns next_hunk<cr>",                 desc = "gitsigns next" },
            { "[g", "<cmd>Gitsigns prev_hunk<cr>",                 desc = "gitsigns prev" },
            { "=", "<cmd>Gitsigns preview_hunk<cr>",              desc = "gitsigns preview" },
            { "-", "<cmd>Gitsigns stage_hunk<cr>",                desc = "gitsigns stage",        mode = { 'n', 'v' } },
            { "gu", "<cmd>Gitsigns reset_hunk<cr>",                desc = "Gitsigns reset" },
            { "gU", "<cmd>Gitsigns undo_stage_hunk<cr>",           desc = "gitsigns undo stage" },

            -- toggles
            { "gl", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git blame current line" },
            { "gL", "<cmd>Gitsigns blame<cr>",                     desc = "Git blame file" },
            { "gW", "<cmd>Gitsigns toggle_word_diff<cr>",          desc = "Git diff words" },
            { "gT", "<cmd>Gitsigns toggle_deleted<cr>",            desc = "Git show deleted" },
        }
    },
}

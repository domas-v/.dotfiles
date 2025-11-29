return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.api.nvim_create_user_command("G", function()
                vim.cmd [[vert Git]]
            end, { desc = "Vert fugitive" })
        end
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
            { "=",  "<cmd>Gitsigns preview_hunk<cr>",              desc = "gitsigns preview" },
            { "-",  "<cmd>Gitsigns stage_hunk<cr>",                desc = "gitsigns stage",        mode = { 'n', 'v' } },
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

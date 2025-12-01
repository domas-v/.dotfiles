return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gg", function() require('neogit').open({ kind = "vsplit" }) end },
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
            { "gv", "<cmd>Gitsigns preview_hunk<cr>",              desc = "gitsigns preview" },
            { "gs", "<cmd>Gitsigns stage_hunk<cr>",                desc = "gitsigns stage",        mode = { 'n', 'v' } },
            { "gu", "<cmd>Gitsigns reset_hunk<cr>",                desc = "Gitsigns reset" },
            { "gU", "<cmd>Gitsigns undo_stage_hunk<cr>",           desc = "gitsigns undo stage" },

            -- toggles
            { "gl", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git blame current line" },
            { "gL", "<cmd>Gitsigns blame<cr>",                     desc = "Git blame file" },
            { "gT", "<cmd>Gitsigns toggle_deleted<cr>",            desc = "Git show deleted" },
        }
    },
}

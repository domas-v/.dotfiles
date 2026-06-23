return {
    {
        enabled = false,
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = { "esmuellert/codediff.nvim" },
        cmd = "Neogit",
        opts = {
            commit_editor = {
                kind = "vsplit",
                show_staged_diff = true,
                spellcheck = false,
            },
        },
        keys = { { "<leader>N", "<cmd>Neogit kind=replace<cr>" }, },
    },
    {
        "esmuellert/codediff.nvim",
        cmd = "CodeDiff",
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function()
            require('gitsigns').setup({ current_line_blame_opts = { delay = 100 } })
        end,
        keys = {
            { "<C-w><C-g>", "<cmd>Gitsigns preview_hunk<cr>", },
            { "]g", "<cmd>Gitsigns next_hunk<cr>", },
            { "[g", "<cmd>Gitsigns prev_hunk<cr>", },
            { "ga", "<cmd>Gitsigns stage_hunk<cr>", },
            { "gu", "<cmd>Gitsigns reset_hunk<cr>", },
            { "gU", "<cmd>Gitsigns undo_stage_hunk<cr>", },
            { "gl", "<cmd>Gitsigns toggle_current_line_blame<cr>", },
            { "gb", "<cmd>Gitsigns blame_line<cr>", },
            { "gB", "<cmd>Gitsigns blame<cr>", },
        }
    },
}

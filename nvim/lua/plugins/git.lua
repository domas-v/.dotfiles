return {
    {
        "NeogitOrg/neogit",
        enabled = true,
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

            vim.api.nvim_create_user_command('G', function()
                vim.cmd('Neogit')
            end, {})
            vim.api.nvim_create_user_command('Gp', function()
                vim.cmd('Neogit push')
            end, {})
            vim.api.nvim_create_user_command('Gl', function()
                vim.cmd('Neogit pull')
            end, {})
            vim.api.nvim_create_user_command('Gc', function()
                vim.cmd('Neogit commit')
            end, {})
        end,
        cmd = { "Neogit" },
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", },
            { "<leader>gp", "<cmd>Neogit pull<cr>", },
            { "<leader>gP", "<cmd>Neogit push<cr>", },
            { "<leader>gc", "<cmd>Neogit commit<cr>", },
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
            { "<leader>gb", "<cmd>Gitsigns blame<cr>",                     desc = "Git blame file" },
            { "<leader>gw", "<cmd>Gitsigns toggle_word_diff<cr>",          desc = "Git diff words" },
            { "<leader>gd", "<cmd>Gitsigns toggle_deleted<cr>",            desc = "Git show deleted" },
        }
    },
    {
        'ruifm/gitlinker.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require "gitlinker".setup()
        end
    }
}

return {
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gswitch", "Gpull", "Gpush", "Gp", "Gl", "GP" },
        keys = {
            { "<leader>G",  "<cmd>vert Git<cr>" },
            { "<leader>gg", "<cmd>vert Git<cr>" },
            { "gL",         "<cmd>Git blame<cr>" },
            { "<leader>gp", "<cmd>Git pull<cr>" },
            { "<leader>gl", "<cmd>Git pull<cr>" },
            { "<leader>gP", "<cmd>Git push<cr>" },
        },
        config = function()
            vim.api.nvim_create_user_command("Gswitch",
                function(opts)
                    vim.cmd("Git switch " .. opts.args)
                end,
                {
                    nargs = "*",
                    complete = function(arglead, cmdline, _)
                        return vim.fn.getcompletion("Git switch " .. arglead, "cmdline")
                    end,
                })

            vim.api.nvim_create_user_command("Gpull",
                function(opts)
                    vim.cmd("Git pull " .. opts.args)
                end,
                { nargs = "*" })
            vim.api.nvim_create_user_command("Gp",
                function(opts)
                    vim.cmd("Git pull " .. opts.args)
                end,
                { nargs = "*" })
            vim.api.nvim_create_user_command("Gl",
                function(opts)
                    vim.cmd("Git pull " .. opts.args)
                end,
                { nargs = "*" })

            vim.api.nvim_create_user_command("Gpush",
                function(opts)
                    vim.cmd("Git push " .. opts.args)
                end,
                { nargs = "*" })
            vim.api.nvim_create_user_command("GP",
                function(opts)
                    vim.cmd("Git push " .. opts.args)
                end,
                { nargs = "*" })
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function()
            require('gitsigns').setup({ current_line_blame_opts = { delay = 100 } })
        end,
        keys = {
            { "<C-w><C-g>", "<cmd>Gitsigns preview_hunk<cr>",              desc = "gitsigns preview" },
            { "<C-w>g",     "<cmd>Gitsigns preview_hunk<cr>",              desc = "gitsigns preview" },
            { "]g",         "<cmd>Gitsigns next_hunk<cr>",                 desc = "gitsigns next" },
            { "[g",         "<cmd>Gitsigns prev_hunk<cr>",                 desc = "gitsigns prev" },
            { "ga",         "<cmd>Gitsigns stage_hunk<cr>",                desc = "gitsigns stage",        mode = { 'n', 'v' } },
            { "gu",         "<cmd>Gitsigns reset_hunk<cr>",                desc = "Gitsigns reset" },
            { "gU",         "<cmd>Gitsigns undo_stage_hunk<cr>",           desc = "gitsigns undo stage" },
            { "gl",         "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git blame current line" },
        }
    },
}

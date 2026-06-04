return {
    {
        enabled = false,
        "tpope/vim-fugitive",
        cmd = {
            "Git",
            "G",
            "Gp",
            "Gl",
            "GP",
            "Gsw",
            "Gst",
        },
        keys = {
            { "<leader>G",  "<cmd>vert Git<cr>" },
            { "<leader>gL", "<cmd>Git blame<cr>" },
        },
        config = function()
            vim.api.nvim_create_user_command("Gtag",
                function(opts)
                    vim.cmd("Git describe --tags --abbrev=0")
                end,
                {})

            vim.api.nvim_create_user_command("Gsw",
                function(opts)
                    vim.cmd("Git switch " .. opts.args)
                end,
                {
                    nargs = "*",
                    complete = function(arglead, cmdline, _)
                        return vim.fn.getcompletion("Git switch " .. arglead, "cmdline")
                    end,
                })
            vim.api.nvim_create_user_command("Gst",
                function(opts)
                    vim.cmd("Git status " .. opts.args)
                end,
                {
                    nargs = "*",
                    complete = function(arglead, cmdline, _)
                        return vim.fn.getcompletion("Git status " .. arglead, "cmdline")
                    end,
                })
            vim.api.nvim_create_user_command("Gl",
                function(opts)
                    vim.cmd("Git pull " .. opts.args)
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
        keys = {
            { "<leader>gg", "<cmd>Neogit kind=auto<cr>" },
            { "<leader>gv", "<cmd>Neogit kind=vsplit<cr>" },
            { "<leader>G",  "<cmd>Neogit kind=tab<cr>" },
            { "<leader>gp", "<cmd>Neogit pull<cr>" },
            { "<leader>gP", "<cmd>Neogit push<cr>" },
            { "<leader>gF", "<cmd>Neogit fetch<cr>" },
            { "<leader>gc", "<cmd>Neogit commit<cr>" },
        },
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

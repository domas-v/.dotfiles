return {
    {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Work", "~/Downloads", "/", "~/Personal" },
            }
        end
    },
    {
        "knubie/vim-kitty-navigator"
    },
    {
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_target = "kitty"
            -- vim.g.slime_python_ipython = 1
            -- vim.g.slime_dont_ask_default = 1
        end,
        keys = {
            { "<C-c><C-f>", "<cmd>%SlimeSend<cr>", "Slime send file" },
        }
    }
}

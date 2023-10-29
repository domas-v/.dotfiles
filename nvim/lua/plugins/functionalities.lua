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
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_target = "kitty"
            vim.cmd [[ let g:slime_default_config = {"pane_direction": "right"} ]]
        end,
        keys = {
            { "<C-c><C-f>", "<cmd>%SlimeSend<cr>", "Slime send file" },
            { "<C-c><C-c>", "<cmd>%SlimeSendCurrentLine<cr>", "Slime send file" },
        }
    }
}

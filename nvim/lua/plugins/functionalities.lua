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
            -- vim.cmd [[ let g:slime_default_config = {"pane_direction": "right"} ]]
        end,
        keys = {
            { "<C-c><C-f>", "<cmd>%SlimeSend<cr>", "Slime send file" },
            { "<C-c><C-c>", "<cmd>%SlimeSendCurrentLine<cr>", "Slime send file" },
        }
    },
    {
        "rest-nvim/rest.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        commit = "8b62563",
        config = function()
            require("rest-nvim").setup({
                result_split_in_place = true,
                result_split_horizontal = true
            })
        end
    }
}

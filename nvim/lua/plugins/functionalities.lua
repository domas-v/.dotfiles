return {
    {
        "hkupty/iron.nvim",
        config = function()
            local iron = require("iron.core")
            local view = require("iron.view")

            iron.setup {
                config = {
                    scratch_repl = false,
                    repl_open_cmd = view.split.vertical.botright(0.5)
                },
                repl_definition = {
                    scheme = {
                        command = { "racket", "-i" }
                    },
                    racket = {
                        command = { "racket", "-i" }
                    },
                    guile = {
                        command = { "racket", "-i" }
                    },
                },
                keymaps = {
                    send_motion = "<space>ic",
                    visual_send = "<space>ic",
                    send_file = "<space>if",
                    send_line = "<space><cr>",
                    clear = "<space>iL",
                    -- cr = "<space><cr>",
                    interrupt = "<space>ix",
                    exit = "<space>iq",
                },
                highlight = {
                    italic = true
                },
                ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
            }
        end,
        keys = {
            { "<leader>ii", "<cmd>IronRepl<cr>" },
            { "<leader>ih", "<cmd>IronReplHere<cr>" },
        },
        cmd = {
            "IronRepl",
            "IronReplHere",
        }
    },
    {
        "rest-nvim/rest.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("rest-nvim").setup()
        end,
        ft = { "http" },
    },
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
        'rmagatti/session-lens',
        dependencies = { 'rmagatti/auto-session', 'nvim-telescope/telescope.nvim' },
        config = function()
            require('session-lens').setup()
        end
    },
    {
        -- TODO: harpoon.nvim
    }
}

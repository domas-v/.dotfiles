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
                    python = {
                        command = { "ipython" }
                    },
                },
                keymaps = {
                    send_file = "<space>if",
                    send_motion = "<space>im",
                    visual_send = "<space><cr>",
                    send_line = "<space><cr>",
                    clear = "<space>il",
                    interrupt = "<space>ix",
                    exit = "<space>iq",
                    -- cr = "<space><cr>",
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
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Work", "~/Downloads", "/", "~/Personal" },
            }
        end
    },
}

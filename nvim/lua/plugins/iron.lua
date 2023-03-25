return {
    {
        'hkupty/iron.nvim',
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
                        command = {"racket", "-i"}
                    },
                    racket = {
                        command = {"racket", "-i"}
                    },
                    guile = {
                        command = {"racket", "-i"}
                    },
                },
                keymaps = {
                    send_motion = "<space>ic",
                    visual_send = "<space>ic",
                    send_file = "<space>if",
                    send_line = "<space>il",
                    clear = "<space>iL",
                    cr = "<space><cr>",
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
    }
}

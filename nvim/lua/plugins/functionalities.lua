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
        "natecraddock/sessions.nvim",
        config = function() require("sessions").setup() end,
    },
    -- {
    --     "akinsho/toggleterm.nvim",
    --     config = function ()
    --         require("toggleterm").setup({
    --             -- size can be a number or function which is passed the current terminal
    --             size = function (term)
    --                 if term.direction == "horizontal" then
    --                     return vim.o.lines * 0.2
    --                 elseif term.direction == "vertical" then
    --                     return vim.o.columns * 0.5
    --                 end
    --             end,
    --             -- size = 50,
    --             direction = "vertical",
    --             open_mapping = [[<c-\>]],
    --             hide_numbers = true,
    --             shade_terminals = true,
    --             start_in_insert = false,
    --             insert_mappings = true,
    --             persist_size = true,
    --             close_on_exit = true,
    --             float_opts = {
    --                 border = "curved",
    --             }
    --         })
    --     end,
    --     keys = {
    --         { "<c-\\>", "<cmd>ToggleTerm<cr>" },
    --         { "<leader>tt", "<cmd>ToggleTerm<cr>" },
    --         { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>" },
    --         { "<leader>ts", "<cmd>ToggleTerm direction=horizontal<cr>" },
    --         { "<leader>tw", "<cmd>ToggleTerm direction=tab<cr>" },
    --         { "<leader>ta", "<cmd>ToggleTermToggleAll<cr>" },
    --         { "<leader>t1", "<cmd>1ToggleTerm<cr>" },
    --         { "<leader>t2", "<cmd>2ToggleTerm<cr>" },
    --         { "<leader>t3", "<cmd>3ToggleTerm<cr>" },
    --     }
    -- }
}

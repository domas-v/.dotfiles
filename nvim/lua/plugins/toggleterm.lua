return {
    {
        'akinsho/toggleterm.nvim',
        config = function ()
            require("toggleterm").setup({
                -- size can be a number or function which is passed the current terminal
                size = function (term)
                    if term.direction == "horizontal" then
                        return vim.o.lines * 0.2
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.5
                    end
                end,
                -- size = 50,
                direction = 'vertical',
                open_mapping = [[<c-\>]],
                hide_numbers = true,
                shade_terminals = true,
                start_in_insert = false,
                insert_mappings = true,
                persist_size = true,
                close_on_exit = true,
                float_opts = {
                    border = 'curved',
                }
            })
        end,
        keys = {
            { "<c-\\>", "<cmd>ToggleTerm<cr>" },
            { "<leader>tt", "<cmd>ToggleTerm<cr>" },
            { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>" },
            { "<leader>ts", "<cmd>ToggleTerm direction=horizontal<cr>" },
            { "<leader>tw", "<cmd>ToggleTerm direction=tab<cr>" },
            { "<leader>ta", "<cmd>ToggleTermToggleAll<cr>" },
            { "<leader>t1", "<cmd>1ToggleTerm<cr>" },
            { "<leader>t2", "<cmd>2ToggleTerm<cr>" },
            { "<leader>t3", "<cmd>3ToggleTerm<cr>" },
        }
    },

}

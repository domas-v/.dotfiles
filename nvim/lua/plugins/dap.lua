return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mfussenegger/nvim-dap-python",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require('dap')
            local dapui = require("dapui")
            if vim.fn.filereadable(".vscode/launch.json") then
                require("dap.ext.vscode").load_launchjs(nil, {})
            end

            --- dapui
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            {
                                id = "repl",
                                size = 0.5
                            },
                            {
                                id = "console",
                                size = 0.5,
                            }
                        },
                        position = "bottom",
                        size = 0.3
                    }
                }
            })

            require("nvim-dap-virtual-text").setup({
                virt_text_win_col = 60
            })

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            --- python
            require('dap-python').setup("python")
            require("dap-python").test_runner = "pytest"

            -- c debuger
            -- require('dap').adapters.lldb = {
            --     type = 'executable',
            --     command = '/opt/homebrew/Cellar/llvm/17.0.6_1/bin/lldb-vscode',
            --     name = 'lldb'
            -- }
            -- require('dap').configurations.c = {
            --     {
            --         name = "Launch",
            --         type = "lldb",
            --         request = "launch",
            --         program = "${fileDirname}/${fileBasenameNoExtension}",
            --         args = {},
            --         cwd = "${fileDirname}",
            --         stopOnEntry = false,
            --         runInTerminal = false,
            --     }
            -- }

            local sign = vim.fn.sign_define
            sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

            local function dap_eval_in_split()
                local buf_name_pattern = '^dap%-eval://'

                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    if vim.api.nvim_buf_get_name(buf):match(buf_name_pattern) then
                        vim.api.nvim_set_current_win(win)
                        return
                    end
                end

                vim.cmd('DapEval')
            end


            vim.keymap.set('n', '<leader>de', dap_eval_in_split, { noremap = true, silent = true })
            vim.keymap.set('x', '<leader>de', dap_eval_in_split, { noremap = true, silent = true })
        end,
        keys = {
            -- debug controls
            { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>",                       desc = "Start DAP" },
            { "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>",                      desc = "Stop DAP" },
            { "<leader>dn", "<cmd>lua require'dap'.step_over()<cr>",                      desc = "Step over" },
            { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>",                      desc = "Step into" },
            { "<leader>do", "<cmd>lua require'dap'.step_out()<cr>",                       desc = "Step out" },
            { "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>",                  desc = "Toggle DAP Repl" },
            { '<leader>dm', "<cmd>lua require('dap-python').test_method()<cr>",           desc = "Test python method" },

            -- ui
            { "<leader>dt", "<cmd>DapVirtualTextToggle<cr>",                              desc = "Toggle DAP Virtual text" },
            { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>",                     desc = "Toggle DAP UI" },
            { "<leader>dE", "<cmd>lua require('dapui').eval()<cr>",                       desc = "DAP Eval",                mode = { "n", "v" } },
            { "<leader>dR", "<cmd>DapVirtualTextForceRefresh<cr>",                        desc = "DAP Refresh virtual text" },

            -- floats
            { "<leader>df", "<cmd>lua require('dapui').float_element()<cr>",              desc = "Toggle DAP Float element" },
            { "<leader>db", "<cmd>lua require('dapui').float_element('breakpoints')<cr>", desc = "Toggle DAP Breakpoints" },
            { "<leader>dw", "<cmd>lua require('dapui').float_element('watches')<cr>",     desc = "Toggle DAP Breakpoints" },
            { "<leader>dc", "<cmd>lua require('dapui').float_element('stacks')<cr>",      desc = "Toggle DAP Breakpoints" },
            { "<leader>dq", "<cmd>lua require('dapui').float_element('scopes')<cr>",      desc = "Toggle DAP Breakpoints" },
        }
    },
    {
        "Weissle/persistent-breakpoints.nvim",
        config = function()
            require('persistent-breakpoints').setup {
                load_breakpoints_event = { "BufReadPost" }
            }

            local opts = { noremap = true, silent = true }
            local keymap = vim.api.nvim_set_keymap
            keymap("n", "<leader>dd", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", opts)
            keymap("n", "<leader>dC", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
        end,
    }
}

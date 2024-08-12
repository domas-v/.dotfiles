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
                layouts = { {
                    elements = {
                        {
                            id = "repl",
                            size = 0.5
                        },
                        {
                            id = "console",
                            size = 0.5
                        }
                    },
                    position = "bottom",
                    size = 0.3
                }, {
                    elements = {
                        {
                            id = "scopes",
                            size = 1.0
                        },
                        -- {
                        --     id = "breakpoints",
                        --     size = 0.33
                        -- }
                    },
                    position = "left",
                    size = 0.25
                } }

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
        end,
        keys = {
            -- debug controls
            { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>",             desc = "Start DAP" },
            { "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>",            desc = "Stop DAP" },
            { "<leader>dn", "<cmd>lua require'dap'.step_over()<cr>",            desc = "Step over" },
            { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>",            desc = "Step into" },
            { "<leader>do", "<cmd>lua require'dap'.step_out()<cr>",             desc = "Step out" },
            { "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>",        desc = "Toggle DAP Repl" },
            { '<leader>dm', "<cmd>lua require('dap-python').test_method()<cr>", desc = "Test python method" },

            -- ui
            { "<leader>dt", "<cmd>DapVirtualTextToggle<cr>", desc = "Toggle DAP Virtual text" },
            { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle DAP UI" },
            { "<leader>de", "<cmd>lua require('dapui').eval()<cr>",   desc = "DAP Eval" },
            { "<leader>dR", "<cmd>DapVirtualTextForceRefresh<cr>", desc = "DAP Refresh virtual text" },

            -- floats
            { "<leader>df", "<cmd>lua require('dapui').float_element()<cr>", desc = "Toggle DAP Float element" },
            { "<leader>db",  "<cmd>lua require('dapui').float_element('breakpoints')<cr>", desc = "Toggle DAP Breakpoints" },
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

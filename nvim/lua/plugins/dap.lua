local eval_buf_pattern = "dap%-eval://"
local repl_winopts = { width = math.floor(vim.o.columns * 0.5) }
local default_opts = { noremap = true, silent = true }


local function _set_autocmd(eval_buf)
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = eval_buf,
        callback = function(args)
            vim.bo[args.buf].modified = false
            local repl = require("dap.repl")
            local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, true)
            repl.execute(table.concat(lines, "\n"))
            repl.open(repl_winopts, "vsp")
        end,
    })
    vim.b[eval_buf].dap_eval_autocmd_registered = true
end

local function _create_eval_buf()
    local eval_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(eval_buf, "dap-eval://" .. vim.bo.filetype)
    vim.bo[eval_buf].swapfile = false
    vim.bo[eval_buf].buftype = "acwrite"
    vim.bo[eval_buf].bufhidden = "hide"
    vim.bo[eval_buf].filetype = vim.bo.filetype

    return eval_buf
end

local function _split_third()
    local total_lines = vim.o.lines
    local split_height = math.floor(total_lines / 3)
    vim.cmd("botright split")
    vim.cmd("resize " .. split_height)
end

local function toggle_dap_ui()
    local repl_buf_pattern = "dap%-repl"
    local eval_win = nil
    local repl_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_name(buf):match(eval_buf_pattern) then
            eval_win = win
        elseif vim.api.nvim_buf_get_name(buf):match(repl_buf_pattern) then
            repl_win = win
        end
    end

    local closed_any = false
    if eval_win then
        vim.api.nvim_win_close(eval_win, true)
        closed_any = true
    end
    if repl_win then
        vim.api.nvim_win_close(repl_win, true)
        closed_any = true
    end

    if closed_any then
        return
    end

    local eval_buf
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf):match(eval_buf_pattern) then
            eval_buf = buf
            break
        end
    end

    if not eval_buf then
        eval_buf = _create_eval_buf()
        if not vim.b[eval_buf].dap_eval_autocmd_registered then
            _set_autocmd(eval_buf)
        end
    end

    _split_third()
    vim.api.nvim_win_set_buf(0, eval_buf)
    require("dap.repl").toggle(repl_winopts, "vsp")
end

local function toggle_dap_repl()
    require('dap').repl.toggle({ height = math.floor(vim.o.lines / 3) })
end

local function list_breakpoints()
    require('dap').list_breakpoints()
    vim.cmd("copen")
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mfussenegger/nvim-dap-python",
            {
                "theHamsta/nvim-dap-virtual-text",
                -- config = function() require("nvim-dap-virtual-text").setup({ virt_text_win_col = 60 }) end
            },
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            local dap = require('dap')
            require('dapui').setup(
                {
                    controls = {
                        element = "repl",
                        enabled = true,
                        icons = {
                            disconnect = "",
                            pause = "",
                            play = "",
                            run_last = "",
                            step_back = "",
                            step_into = "",
                            step_out = "",
                            step_over = "",
                            terminate = ""
                        }
                    },
                    element_mappings = {},
                    expand_lines = true,
                    floating = {
                        border = "single",
                        mappings = {
                            close = { "q", "<Esc>" }
                        }
                    },
                    force_buffers = true,
                    icons = {
                        collapsed = "",
                        current_frame = "",
                        expanded = ""
                    },
                    layouts = {
                        {
                            elements = {
                                {
                                    id = "scopes",
                                    size = 0.5
                                },
                                -- {
                                --     id = "breakpoints",
                                --     size = 0.5
                                -- },
                                -- {
                                --     id = "stacks",
                                --     size = 0.5
                                -- },
                                {
                                    id = "watches",
                                    size = 0.5
                                },
                            },
                            position = "right",
                            size = 40
                        },
                    },
                    mappings = {
                        edit = "e",
                        expand = { "<CR>", "<2-LeftMouse>" },
                        open = "o",
                        remove = "d",
                        repl = "r",
                        toggle = "t"
                    },
                    render = {
                        indent = 1,
                        max_value_lines = 100
                    }
                })

            dap.defaults.fallback.terminal_win_cmd = 'tabnew'

            -- c
            dap.adapters.codelldb = {
                type = "executable",
                command = "/Users/domas-v/.vscode/extensions/vadimcn.vscode-lldb-1.11.5/adapter/codelldb",
            }
            dap.configurations.c = dap.configurations.cpp
            --- python
            require('dap-python').setup("python")
            require("dap-python").test_runner = "pytest"

            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            vim.api.nvim_create_user_command("DapUIToggle", toggle_dap_ui, {})
            vim.keymap.set('n', '<leader>du', "<cmd>DapUIToggle<cr>", default_opts)
            vim.keymap.set('n', '<leader>dr', "<cmd>DapUIToggle<cr>", default_opts)
            vim.keymap.set('n', '<C-w>r', "<cmd>DapUIToggle<cr>", default_opts)
            vim.keymap.set('n', '<C-w><C-r>', "<cmd>DapUIToggle<cr>", default_opts)
            vim.api.nvim_create_user_command("DapReplToggle", toggle_dap_repl, {})
            vim.keymap.set('n', '<leader>dr', "<cmd>DapReplToggle<cr>", default_opts)
            vim.api.nvim_create_user_command("DapListBreakpoints", list_breakpoints, {})
        end,
        keys = {
            { "<C-w>e",     "<cmd>lua require('dap.ui.widgets').hover(nil, { border = 'rounded' })<cr>", },
            { "<C-w><C-e>", "<cmd>lua require('dap.ui.widgets').hover(nil, { border = 'rounded' })<cr>", },
            { "<C-w><C-u>", "<cmd>lua require('dapui').toggle()<cr>", },
            { "<leader>dd", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", },
            { "<leader>dC", "<cmd>lua require'dap'.clear_breakpoints()<cr>", },
            { "<leader>db", "<cmd>DapListBreakpoints<cr>", },
            { "<leader>df", "<cmd>lua require'dap'.run_to_cursor()<cr>", },
            { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>", },
            { "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>", },
            { "<leader>dn", "<cmd>lua require'dap'.step_over()<cr>", },
            { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", },
            { "<leader>do", "<cmd>lua require'dap'.step_out()<cr>", },
            { '<leader>dm', "<cmd>lua require('dap-python').test_method()<cr>", },
            { "<leader>dt", "<cmd>DapVirtualTextToggle<cr>", },
        }
    },
}

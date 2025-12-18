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

local function toggle_dap_eval()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_name(buf):match(eval_buf_pattern) then
            vim.api.nvim_win_close(win, true)
            return
        end
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

    vim.cmd("only")
    _split_third()
    vim.api.nvim_win_set_buf(0, eval_buf)
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
                config = function() require("nvim-dap-virtual-text").setup({ virt_text_win_col = 60 }) end
            },
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require('dap')
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
            vim.api.nvim_create_user_command("DapEvalToggle", toggle_dap_eval, {})
            vim.keymap.set('n', '<leader>de', "<cmd>DapEvalToggle<cr>", default_opts)
            vim.keymap.set('v', '<leader>de', "<cmd>DapEval<cr>", default_opts)
            vim.api.nvim_create_user_command("DapReplToggle", toggle_dap_repl, {})
            vim.keymap.set('n', '<leader>dr', "<cmd>DapReplToggle<cr>", default_opts)
            vim.api.nvim_create_user_command("DapListBreakpoints", list_breakpoints, {})
        end,
        keys = {
            { "<C-w>e", "<cmd>lua require('dap.ui.widgets').hover(nil, { border = 'rounded' })<cr>",                                       desc = "DAP hover variable" },
            { "<C-w>r", "<cmd>lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes, { border = 'rounded' })<cr>", desc = "DAP scopes" },
            { "<C-w><C-e>", "<cmd>lua require('dap.ui.widgets').hover(nil, { border = 'rounded' })<cr>",                                       desc = "DAP hover variable" },
            { "<C-w><C-r>", "<cmd>lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes, { border = 'rounded' })<cr>", desc = "DAP scopes" },
            { "<leader>dd", "<cmd>lua require'dap'.toggle_breakpoint()<cr>",                                                                   desc = "Start DAP", },
            { "<leader>dC", "<cmd>lua require'dap'.clear_breakpoints()<cr>",                                                                   desc = "Start DAP", },
            { "<leader>db", "<cmd>DapListBreakpoints<cr>",                                                                                     desc = "Start DAP", },
            { "<leader>df", "<cmd>lua require'dap'.run_to_cursor()<cr>",                                                                   desc = "Start DAP", },
            { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>",                                                                            desc = "Start DAP" },
            { "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>",                                                                           desc = "Stop DAP" },
            { "<leader>dn", "<cmd>lua require'dap'.step_over()<cr>",                                                                           desc = "Step over" },
            { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>",                                                                           desc = "Step into" },
            { "<leader>do", "<cmd>lua require'dap'.step_out()<cr>",                                                                            desc = "Step out" },
            { '<leader>dm', "<cmd>lua require('dap-python').test_method()<cr>",                                                                desc = "Test python method" },
            { "<leader>dt", "<cmd>DapVirtualTextToggle<cr>",                                                                                   desc = "DAP Virtual text" },
        }
    },
}

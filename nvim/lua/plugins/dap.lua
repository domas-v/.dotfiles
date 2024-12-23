local api = vim.api
local eval_buf_pattern = "dap%-eval://"
local repl_winopts = { width = math.floor(vim.o.columns * 0.5) }

local function _set_autocmd(eval_buf)
    api.nvim_create_autocmd("BufWriteCmd", {
        buffer = eval_buf,
        callback = function(args)
            vim.bo[args.buf].modified = false
            local repl = require("dap.repl")
            local lines = api.nvim_buf_get_lines(args.buf, 0, -1, true)
            repl.execute(table.concat(lines, "\n"))
            repl.open(repl_winopts, "vsp")
        end,
    })
    vim.b[eval_buf].dap_eval_autocmd_registered = true
end

local function _create_eval_buf()
    local eval_buf = api.nvim_create_buf(true, true)
    api.nvim_buf_set_name(eval_buf, "dap-eval://" .. vim.bo.filetype)
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
    for _, win in ipairs(api.nvim_list_wins()) do
        local buf = api.nvim_win_get_buf(win)
        if api.nvim_buf_get_name(buf):match(eval_buf_pattern) then
            eval_win = win
        elseif api.nvim_buf_get_name(buf):match(repl_buf_pattern) then
            repl_win = win
        end
    end

    local closed_any = false
    if eval_win then
        api.nvim_win_close(eval_win, true)
        closed_any = true
    end
    if repl_win then
        api.nvim_win_close(repl_win, true)
        closed_any = true
    end

    if closed_any then
        return
    end

    local eval_buf
    for _, buf in ipairs(api.nvim_list_bufs()) do
        if api.nvim_buf_get_name(buf):match(eval_buf_pattern) then
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
    api.nvim_win_set_buf(0, eval_buf)
    require("dap.repl").toggle(repl_winopts, "vsp")
end

local function toggle_dap_eval()
    for _, win in ipairs(api.nvim_list_wins()) do
        local buf = api.nvim_win_get_buf(win)
        if api.nvim_buf_get_name(buf):match(eval_buf_pattern) then
            api.nvim_win_close(win, true)
            return
        end
    end

    local eval_buf
    for _, buf in ipairs(api.nvim_list_bufs()) do
        if api.nvim_buf_get_name(buf):match(eval_buf_pattern) then
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
    api.nvim_win_set_buf(0, eval_buf)
end

local function toggle_dap_repl()
    require('dap').repl.toggle({ height = math.floor(vim.o.lines / 3) })
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mfussenegger/nvim-dap-python",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require('dap')
            if vim.fn.filereadable(".vscode/launch.json") then
                require("dap.ext.vscode").load_launchjs(nil, {})
            end

            dap.defaults.fallback.terminal_win_cmd = 'tabnew'
            require("nvim-dap-virtual-text").setup({ virt_text_win_col = 60 })

            --- python
            require('dap-python').setup("python")
            require("dap-python").test_runner = "pytest"

            -- c
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

            api.nvim_create_user_command("DapUIToggle", toggle_dap_ui, {})
            api.nvim_create_user_command("DapEvalToggle", toggle_dap_eval, {})
            api.nvim_create_user_command("DapReplToggle", toggle_dap_repl, {})
            vim.keymap.set('n', '<leader>du', "<cmd>DapUIToggle<cr>", { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>de', "<cmd>DapEvalToggle<cr>", { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>dr', "<cmd>DapReplToggle<cr>", { noremap = true, silent = true })
        end,
        keys = {
            -- debug controls
            { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>",             desc = "Start DAP" },
            { "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>",            desc = "Stop DAP" },
            { "<leader>dn", "<cmd>lua require'dap'.step_over()<cr>",            desc = "Step over" },
            { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>",            desc = "Step into" },
            { "<leader>do", "<cmd>lua require'dap'.step_out()<cr>",             desc = "Step out" },
            { '<leader>dm', "<cmd>lua require('dap-python').test_method()<cr>", desc = "Test python method" },
            { "<leader>dt", "<cmd>DapVirtualTextToggle<cr>",                    desc = "Toggle DAP Virtual text" },
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

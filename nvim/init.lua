require("settings")
require("keybindings")
require("config.lazy")

vim.cmd("colorscheme catppuccin")

require("config.commands")

require("config.todos")

-- filetype fixes
vim.filetype.add({ extension = { http = "http" } })
vim.filetype.add({ extension = { dbout = "dbout" } })
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'mysql',
    callback = function()
        vim.bo.commentstring = "-- %s"
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        local function badge_hl(name, source)
            local hl = vim.api.nvim_get_hl(0, { name = source, link = false })
            vim.api.nvim_set_hl(0, name, { bg = hl.fg, fg = hl.bg or "#1e1e2e", bold = true })
        end

        badge_hl("MarkdownTodo", "DiagnosticWarn")
        badge_hl("MarkdownDoing", "DiagnosticInfo")
        badge_hl("MarkdownWaiting", "DiagnosticOK")
        badge_hl("MarkdownImportant", "DiagnosticError")

        vim.fn.matchadd("MarkdownTodo", "TODO")
        vim.fn.matchadd("MarkdownDoing", "DOING")
        vim.fn.matchadd("MarkdownWaiting", "WAITING")
        vim.fn.matchadd("MarkdownImportant", "IMPORTANT")
    end,
})

-- Enable completion for DAP-REPL filetypes for blink.cmp
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-repl", "dapui_watches", "dapui_hover" },
    callback = function()
        vim.b.completion = true
    end,
    desc = "Enable completion for DAP-REPL filetypes"
})

require("settings")
require("keybindings")
require("config.lazy")

vim.cmd("colorscheme kanagawa")

require("config.statusline")
require("config.bufferline")
require("config.commands")

-- filetype fixes
vim.filetype.add({ extension = { http = "http" } })
vim.filetype.add({ extension = { dbout = "dbout" } })
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'mysql',
    callback = function()
        vim.bo.commentstring = "-- %s"
    end
})

-- Enable completion for DAP-REPL filetypes for blink.cmp
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-repl", "dapui_watches", "dapui_hover" },
    callback = function()
        vim.b.completion = true
    end,
    desc = "Enable completion for DAP-REPL filetypes"
})


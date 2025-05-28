require("settings")
require("keybindings")
require("config.lazy")

vim.cmd("colorscheme kanagawa")

-- HACK: http filetype is not detected somehow. this is a fix
vim.filetype.add({ extension = { http = "http" } })

-- HACK: Enable completion for DAP-REPL filetypes for blink.cmp
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-repl", "dapui_watches", "dapui_hover" },
    callback = function()
        vim.b.completion = true
    end,
    desc = "Enable completion for DAP-REPL filetypes"
})

-- HACK: For folds
vim.api.nvim_set_hl(0, "FoldColumn", {})
vim.api.nvim_set_hl(0, "Folded", { bg = "NONE" })

local map         = vim.keymap.set

vim.o.tabstop     = 2
vim.o.shiftwidth  = 2
vim.o.softtabstop = 2

map("n", "<leader>cc", function()
    local file = vim.fn.expand("%")
    local output = vim.fn.expand("%:r")

    local cmd = string.format("clang %s -g -o %s.out", file, output)
    vim.fn.system(cmd)

    print("Compiled:", cmd)
end, { buffer = true, silent = true })

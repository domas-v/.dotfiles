vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf", -- in quickfix list
    callback = function() vim.keymap.set("n", "q", "<cmd>cclose<cr>", { buffer = true, silent = true }) end
})


-- opens in system file explorer
vim.api.nvim_create_user_command("OpenDir", function()
    local dir = vim.fn.expand('%:p:h')
    os.execute('open ' .. vim.fn.shellescape(dir))
end, { desc = "Open current file's directory in system file explorer" })

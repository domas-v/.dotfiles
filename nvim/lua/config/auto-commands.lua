vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf", -- in quickfix list
    callback = function() vim.keymap.set("n", "q", "<cmd>cclose<cr>", { buffer = true, silent = true }) end
})

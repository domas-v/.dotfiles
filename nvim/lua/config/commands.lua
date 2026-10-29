vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function() vim.keymap.set("n", "q", "<cmd>cclose<cr>", { buffer = true, silent = true }) end
})

-- highlight #tags in markdown
local function set_tag_hl()
    local special = vim.api.nvim_get_hl(0, { name = "Special", link = false })
    vim.api.nvim_set_hl(0, "NotesTag", { fg = special.fg, italic = true })
end
set_tag_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_tag_hl })

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
    callback = function()
        local markdown = vim.bo.filetype == "markdown"
        if markdown and not vim.w.notes_tag_match then
            vim.w.notes_tag_match = vim.fn.matchadd("NotesTag", [=[\v(^|\s)\zs#[[:alpha:]][[:alnum:]_/-]*]=])
        elseif not markdown and vim.w.notes_tag_match then
            pcall(vim.fn.matchdelete, vim.w.notes_tag_match)
            vim.w.notes_tag_match = nil
        end
    end,
})

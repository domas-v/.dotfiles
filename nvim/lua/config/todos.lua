local function work_todo()
    local path = "~/Projects/tenspeed-lambda/dev/todo.md"
    vim.cmd("edit " .. path)
    vim.cmd("normal! gg")
end
vim.keymap.set("n", "<leader>nw", work_todo)

local function personal_todo()
    local path = "~/Desktop/Notes/todo.md"
    vim.cmd("edit " .. path)
    vim.cmd("normal! gg")
end
vim.keymap.set("n", "<leader>nn", personal_todo)

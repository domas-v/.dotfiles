vim.g.mapleader = " "
vim.g.maplocalleader = ";"
local map = vim.keymap.set

-- move visual selection
map("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move visual line down' })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move visual line up' })
map("v", "<", "<gv", { desc = 'Move visual line left' })
map("v", ">", ">gv", { desc = 'Move visual line right' })

-- wrapped line movement
map("n", "k", "gk")
map("n", "j", "gj")
map("n", "0", "g0")
map("n", "$", "g$")
map("n", "Y", "y$")

-- handy remaps
map("n", "!", ":!", { desc = 'Run shell command' })
map("n", "<C-;>", ":lua ", { desc = 'Enter lua command' })
map("n", "J", "mzJ`z", { desc = 'Join lines' })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "<leader>q", "<cmd>close<cr>")
map("n", "<C-q>", "<cmd>close<cr>")
map("n", "zq", "<cmd>wqa!<cr>")
map("n", "<esc>", "<cmd>nohl<cr>")
map("n", "<leader><leader>w", "<cmd>set wrap!<cr>")

-- yank to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

-- pop up movement
map('i', '<C-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map('i', '<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })
map('c', '<C-k>', '<LEFT>', { noremap = true })
map('c', '<C-j>', '<RIGHT>', { noremap = true })

-- search & replace
map("n", "<C-s>", "/")                                                        -- word under cursor
map("n", "<leader>R", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- word under cursor
map("v", "<leader>rr", ":s/", { desc = "Search & Replace" })                  -- in visual selection
map("n", "<leader>rr", ":%s/", { desc = "Search & Replace" })                 -- in whole buffer
map("n", "<leader>rq", ":cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
    { desc = "Search & Replace" })                                            -- in quickfix list

-- windows/buffers
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- tabs
map("n", "<C-t><C-t>", "<cmd>tab split<cr>")
map("n", "<C-t><C-x>", "<cmd>tabclose<cr>")

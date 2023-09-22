vim.g.mapleader = " "
vim.g.maplocalleader = ";"
local map = vim.keymap.set

-- move visual selection
map("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move visual line down' })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move visual line up' })
map("v", "<", "<gv", { desc = 'Move visual line left' })
map("v", ">", ">gv", { desc = 'Move visual line right' })

-- escape terminal
map("t", "<C-x>", "<C-\\><C-n>", { desc = 'Escape terminal' })

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
map("n", "<C-e>", "<C-u>zz")
map("n", "<leader>q", "<cmd>close<cr>")
map("n", "<leader>Q", "<cmd>qa<cr>")
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
map("n", "<leader>R", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])                                                                        -- word under cursor
map("v", "<leader>rr", ":s/", { desc = "Search & Replace" })                                                                                         -- in visual selection
map("n", "<leader>rr", ":%s/", { desc = "Search & Replace" })                                                                                        -- in whole buffer
map("n", "<leader>rq", ":cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
    { desc = "Search & Replace" })                                                                                                                   -- in quickfix list
map("n", "<C-s>", "/")
map("n", "<C-a>", "?")
map("i", "<C-s>", "<esc>/")
map("i", "<C-a>", "<esc>?")

-- windows/buffers
map("i", "<C-s>", "<esc>/")
map("n", "<leader>wv", ":vert sb ")
map("n", "<leader>ws", ":sbuffer ")
map("n", "<leader>wo", "<cmd>only<cr>")
map("n", "<leader>X", "<cmd>bd! %<cr>")
map("n", "<leader>O", "<cmd>only<cr>")

-- tabs
map("n", "<C-w>t", "<cmd>tab split<cr>")
map("n", "<C-w>x", "<cmd>tabclose<cr>")

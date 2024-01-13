vim.g.mapleader = " "
vim.g.maplocalleader = ";"
local map = vim.keymap.set

-- move visual selection
map("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move visual line down' })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move visual line up' })
map("v", "H", "<gv", { desc = 'Move visual line left' })
map("v", "L", ">gv", { desc = 'Move visual line right' })
map("n", "J", "mzJ`z", { desc = 'Join lines' })

-- wrapped line movement
map("n", "k", "gk")
map("n", "j", "gj")
map("n", "0", "g0")
map("n", "$", "g$")
map("n", "Y", "y$")

-- commands
map("n", "!", ":!", { desc = 'Run shell command' })
map("n", "<C-;>", ":lua ", { desc = 'Enter lua command' })

-- scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- move to first/last non-blank character
map("n", "L", "g$")
map("n", "H", "_")

-- move to first/last character
map("n", "gL", "$")
map("n", "gH", "|")

-- closing vim
map("n", "<leader>q", "<cmd>close<cr>")
map("n", "<C-q>", "<cmd>close<cr>")
map("n", "zq", "<cmd>wqa!<cr>")
map("n", "<esc>", "<cmd>nohl<cr>")

-- word wrap
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
map("n", "<C-s>", "/")
map("n", "<leader>R", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- word under cursor
map("v", "<leader>rr", ":s/", { desc = "Search & Replace" })                  -- in visual selection
map("n", "<leader>rr", ":%s/", { desc = "Search & Replace" })                 -- in whole buffer
map("n", "<leader>rq", ":cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
    { desc = "Search & Replace" })                                            -- in quickfix list

-- tabs
map("n", "<C-t><C-t>", "<cmd>tab split<cr>")
map("n", "<C-t><C-x>", "<cmd>tabclose<cr>")

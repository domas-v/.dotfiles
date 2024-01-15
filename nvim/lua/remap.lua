local map = vim.keymap.set

-- unamp leader and localleader
map("n", "<Space>", "<Nop>", { noremap=true, silent=true })
map("n", ";", "<Nop>", { noremap=true, silent=true })
map("n", "Q", "<Nop>", { noremap=true, silent=true })

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- some keybindings to think about
-- <TAB>
-- <C-SPACE>
-- z-commands
-- x-commands


-- insert mode keybindings
map("i", "<C-a>", "<Home>",  { noremap = true, silent = true })
map("i", "<C-f>", "<Right>", { noremap = true, silent = true })
map("i", "<C-b>", "<Left>",  { noremap = true, silent = true })
map("i", "<C-e>", "<End>",   { noremap = true, silent = true })
map("i", "<C-d>", "<Del>",   { noremap = true, silent = true })
map("i", "<C-u>", "<C-G>u<C-U>", { noremap = true, silent = true })

-- move visual selection
map("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move visual line down', noremap=true })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move visual line up', noremap=true })
map("v", "H", "<gv", { desc = 'Move visual line left', noremap=true })
map("v", "L", ">gv", { desc = 'Move visual line right', noremap=true })
map("n", "J", "mzJ`z", { desc = 'Join lines', noremap=true })

-- wrapped line movement
map("n", "k", "gk", { noremap=true })
map("n", "j", "gj", { noremap=true })

-- move to first/last non-blank character
map("n", "L", "g$", { noremap=true })
map("n", "H", "_", { noremap=true })

-- move to first/last character
map("n", "gL", "$", { noremap=true })
map("n", "gH", "|", { noremap=true })

-- commands
map("n", "!", ":!", { desc = 'Run shell command', noremap=true })
map("n", "<C-;>", ":lua ", { desc = 'Enter lua command', noremap=true })

-- scrolling
map("n", "<C-d>", "<C-d>zz", { desc = 'Scroll down', noremap=true })
map("n", "<C-u>", "<C-u>zz", { desc = 'Scroll up', noremap=true })
map("n", "T", "gg", { noremap=true })

-- closing vim
map("n", "<leader>q", "<cmd>close<cr>", { noremap=true })
map("n", "<C-q>", "<cmd>close<cr>", { noremap=true })
-- map("n", "zc", "<cmd>wqa!<cr>", { noremap=true })
map("n", "zq", "<cmd>qa!<cr>", { noremap=true })

-- word wrap
map("n", "<leader><leader>w", "<cmd>set wrap!<cr>", { noremap=true })

-- undo/redo
map("n", "U", "<C-r>", { noremap=true })

-- yanking
map({ "n", "v" }, "<leader>y", [["+y]], { noremap=true })
map("n", "<leader>Y", [["+Y]], { noremap=true })
map("n", "Y", "y$", { noremap=true })

-- folding
map("n", "zf", "za", { noremap=true })
map("n", "zF", "zA", { noremap=true })

-- paste over visual selection (if doesn't work as expected, rebind to leader-p)
map("x", "p", [["_dP]]) 

-- pop up movement
map('i', '<C-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map('i', '<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })
map('c', '<C-k>', '<LEFT>', { noremap = true })
map('c', '<C-j>', '<RIGHT>', { noremap = true })

-- search & replace
map("n", "<C-s>", "/", { noremap=true })
map("n", "<esc>", "<cmd>nohl<cr>", { noremap=true })
map("n", "<leader>R", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { noremap=true }) -- word under cursor
map("v", "<leader>rr", ":s/", { desc = "Search & Replace" , noremap=true })                  -- in visual selection
map("n", "<leader>rr", ":%s/", { desc = "Search & Replace", noremap=true })                 -- in whole buffer
map("n", "<leader>rq", ":cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
{ desc = "Search & Replace" }, { noremap=true })                                            -- in quickfix list

-- tabs
map("n", "<C-t><C-t>", "<cmd>tab split<cr>", { noremap=true })
map("n", "<C-t><C-x>", "<cmd>tabclose<cr>", { noremap=true })


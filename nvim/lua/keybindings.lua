local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

-- leader keys
map("n", "<Space>", "<Nop>", { noremap = true, silent = true })
map("n", "Q", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "

-- mouse
map("n", "<S-ScrollWheelUp>", "zh", { noremap = true, silent = true })
map("n", "<S-ScrollWheelDown>", "zl", { noremap = true, silent = true })

-- insert mode keybindings
map("i", "<C-a>", "<Home>", { noremap = true, silent = true })
map("i", "<C-f>", "<Right>", { noremap = true, silent = true })
map("i", "<C-b>", "<Left>", { noremap = true, silent = true })
map("i", "<C-e>", "<End>", { noremap = true, silent = true })
map("i", "<C-d>", "<Del>", { noremap = true, silent = true })
map("i", "<C-u>", "<C-G>u<C-U>", { noremap = true, silent = true })

-- move visual selection
map("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move visual line down', noremap = true })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move visual line up', noremap = true })
map("v", "H", "<gv", { desc = 'Move visual line left', noremap = true })
map("v", "L", ">gv", { desc = 'Move visual line right', noremap = true })

-- join lines
map("n", "J", "mzJ`z", { desc = 'Join lines', noremap = true })

-- wrapped line movement
map("n", "k", "gk", { noremap = true })
map("n", "j", "gj", { noremap = true })

-- move to first/last characters
map("n", "L", "g$", { noremap = true })
map("n", "H", "_", { noremap = true })
map("n", "gl", "$", { noremap = true })
map("n", "gh", "|", { noremap = true })

-- scrolling
map("n", "<C-d>", "<C-d>zz", { desc = 'Scroll down', noremap = true })
map("n", "<C-u>", "<C-u>zz", { desc = 'Scroll up', noremap = true })
map("n", "<M-l>", "zl", { desc = 'Scroll right', noremap = true })
map("n", "<M-L>", "zL", { desc = 'Scroll right more', noremap = true })
map("n", "<M-h>", "zh", { desc = 'Scroll left', noremap = true })
map("n", "<M-H>", "zH", { desc = 'Scroll left more', noremap = true })

-- commands
map("n", "!", ":!", { desc = 'Run shell command', noremap = true })
map("n", "<C-S-;>", ":lua ", { desc = 'Enter lua command', noremap = true })

-- closing vim
map("n", "<C-q>", "<cmd>close<cr>", { noremap = true })
map("n", "<leader>Q", "<cmd>wqa!<cr>", { noremap = true })

-- word wrap
map("n", "<leader>ww", "<cmd>set wrap!<cr>", { noremap = true })

-- undo/redo
map("n", "U", "<C-r>", { noremap = true })

-- yanking & pasting
map("n", "Y", "y$", { noremap = true })
map("x", "p", [["_dP]]) -- paste over visual selection (if doesn't work as expected, rebind to leader-p)

-- pop up movement
map('i', '<-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map('i', '<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })
map('c', '<C-j>', '<RIGHT>', { noremap = true })
map('c', '<C-k>', '<LEFT>', { noremap = true })

-- search highlighting
map("n", "<esc>", "<cmd>nohl<cr>", { noremap = true })

-- tabs
map("n", "<leader>tt", "<cmd>tab split<cr>", { noremap = true })
map("n", "<leader>tx", "<cmd>tabclose<cr>", { noremap = true })
map("n", "<leader>to", "<cmd>tabonly<cr>", { noremap = true })

-- buffers
map("n", "<C-S-x>", "<cmd>bd<cr>", { noremap = true })
map("n", "<C-n>", "<cmd>bnext<cr>", { noremap = true })
map("n", "<C-p>", "<cmd>bprev<cr>", { noremap = true })
map("n", "<C-b>", "<cmd>b#<cr>", { noremap = true })

-- quickfix
map("n", "<leader>co", "<cmd>copen<cr>", { noremap = true })
map("n", "<leader>cr", ":cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
    { noremap = true }) -- in quickfix list
autocmd("FileType", {
    pattern = "qf",
    callback = function() map("n", "q", "<cmd>cclose<cr>", { buffer = true, silent = true }) end
})

-- windows
map("n", "<C-h>", "<C-w>h", { noremap = true })
map("n", "<C-j>", "<C-w>j", { noremap = true })
map("n", "<C-k>", "<C-w>k", { noremap = true })
map("n", "<C-l>", "<C-w>l", { noremap = true })

-- resize splits
map("n", "<M-,>", "<C-w>7<")
map("n", "<M-.>", "<C-w>7>")
map("n", "<M-]>", "5<C-W>+")
map("n", "<M-[>", "5<C-W>-")

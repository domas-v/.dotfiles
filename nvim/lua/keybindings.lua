local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local default_opts = { noremap = true, silent = true }

-- leader keys
map("n", "<Space>", "<Nop>", default_opts)
map("n", "Q", "<Nop>", default_opts)
vim.g.mapleader = " "

-- mouse
map("n", "<S-ScrollWheelUp>", "zh", default_opts)
map("n", "<S-ScrollWheelDown>", "zl", default_opts)

-- insert mode keybindings
map("i", "<C-a>", "<Home>", default_opts)
map("i", "<C-f>", "<Right>", default_opts)
map("i", "<C-b>", "<Left>", default_opts)
map("i", "<C-e>", "<End>", default_opts)
map("i", "<C-d>", "<Del>", default_opts)
map("i", "<C-u>", "<C-G>u<C-U>", default_opts)

-- move visual selection
map("v", "J", ":m '>+1<CR>gv=gv", default_opts)
map("v", "K", ":m '<-2<CR>gv=gv", default_opts)
map("v", "H", "<gv", default_opts)
map("v", "L", ">gv", default_opts)

-- join lines
map("n", "J", "mzJ`z", default_opts)

-- wrapped line movement
map("n", "k", "gk", default_opts)
map("n", "j", "gj", default_opts)

-- move to first/last characters
map("n", "L", "g$", default_opts)
map("n", "H", "_", default_opts)
map("n", "gl", "$", default_opts)
map("n", "gh", "|", default_opts)

-- scrolling
map("n", "<C-d>", "<C-d>zz", default_opts)
map("n", "<C-u>", "<C-u>zz", default_opts)
map("n", "<C-S-l>", "zl", default_opts)
map("n", "<C-S-h>", "zh", default_opts)
map("n", "<C-M-L>", "zL", default_opts)
map("n", "<C-M-H>", "zH", default_opts)

-- commands
map("n", "!", ":!", default_opts)
map("n", "<C-S-;>", ":lua ", default_opts)

-- saving and closing
map("n", "<C-q>", "<cmd>close<cr>", default_opts)
map("n", "<leader>Q", "<cmd>qa<cr>", default_opts)
map("n", "<leader>W", "<cmd>wa<cr>", default_opts)

-- word wrap
map("n", "<leader><leader>w", "<cmd>set wrap!<cr>", { noremap = true })

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
map("n", "<leader>tn", "<cmd>tabnew<cr>", { noremap = true })

-- buffers
map("n", "<C-S-x>", "<cmd>bd<cr>", default_opts)
-- map("n", "<C-n>", "<cmd>bnext<cr>", default_opts)
-- map("n", "<C-p>", "<cmd>bprev<cr>", default_opts)
-- map("n", "<C-b>", "<cmd>b#<cr>", default_opts)

-- quickfix
map("n", "<leader>cj", "<cmd>cnext<cr>", { noremap = true })
map("n", "<leader>ck", "<cmd>cprevious<cr>", { noremap = true })
map("n", "<leader>co", "<cmd>copen<cr>", { noremap = true })
map("n", "<leader>cc", "<cmd>cclose<cr>", { noremap = true })
map("n", "<leader>cr", ":cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
    { noremap = true }) -- in quickfix list
autocmd("FileType", {
    pattern = "qf",
    callback = function() map("n", "q", "<cmd>cclose<cr>", { buffer = true, silent = true }) end
})

-- help
autocmd("FileType", {
    pattern = "help",
    callback = function() map("n", "q", "<cmd>close<cr>", { buffer = true, silent = true }) end
})

-- windows
map("n", "<C-h>", "<C-w>h", default_opts)
map("n", "<C-j>", "<C-w>j", default_opts)
map("n", "<C-k>", "<C-w>k", default_opts)
map("n", "<C-l>", "<C-w>l", default_opts)

-- resize splits
map("n", "<C-->", "<C-w>10<", default_opts)
map("n", "<C-=>", "<C-w>10>", default_opts)
map("n", "<C-S-->", "5<C-W>+", default_opts)
map("n", "<C-S-=>", "5<C-W>-", default_opts)

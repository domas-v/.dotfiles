local default_opts = { noremap = true, silent = true }

-- leader keys
vim.keymap.set("n", "<Space>", "<Nop>", default_opts)
vim.keymap.set("n", "Q", "<Nop>", default_opts)
vim.g.mapleader = " "

-- mouse
vim.keymap.set("n", "<S-ScrollWheelUp>", "zh", default_opts)
vim.keymap.set("n", "<S-ScrollWheelDown>", "zl", default_opts)

-- insert mode navigation
vim.keymap.set("i", "<C-a>", "<Home>", default_opts)
vim.keymap.set("i", "<C-f>", "<Right>", default_opts)
vim.keymap.set("i", "<C-b>", "<Left>", default_opts)
vim.keymap.set("i", "<C-e>", "<End>", default_opts)
vim.keymap.set("i", "<C-d>", "<Del>", default_opts)
vim.keymap.set("i", "<C-u>", "<C-G>u<C-U>", default_opts)

-- move visual selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", default_opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", default_opts)
vim.keymap.set("v", "H", "<gv", default_opts)
vim.keymap.set("v", "L", ">gv", default_opts)

-- join lines
vim.keymap.set("n", "J", "mzJ`z", default_opts)

-- wrapped line movement
vim.keymap.set("n", "k", "gk", default_opts)
vim.keymap.set("n", "j", "gj", default_opts)

-- move to first/last characters
vim.keymap.set("n", "L", "g$", default_opts)
vim.keymap.set("n", "H", "_", default_opts)

-- scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", default_opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", default_opts)
vim.keymap.set("n", "<C-S-l>", "zL", default_opts)
vim.keymap.set("n", "<C-S-h>", "zH", default_opts)

-- saving and closing
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", default_opts)
vim.keymap.set("n", "<leader>W", "<cmd>wa<cr>", default_opts)
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", default_opts)

-- undo/redo
vim.keymap.set("n", "U", "<C-r>", { noremap = true })

-- yanking & pasting
vim.keymap.set("n", "Y", "y$", { noremap = true })
vim.keymap.set("x", "p", [["_dP]])

-- pop up movement
vim.keymap.set('i', '<-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
vim.keymap.set('i', '<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })
vim.keymap.set('c', '<C-j>', '<RIGHT>', { noremap = true })
vim.keymap.set('c', '<C-k>', '<LEFT>', { noremap = true })

-- search highlighting
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr>", { noremap = true })

-- tabs
vim.keymap.set("n", "<leader>tt", "<cmd>tab split<cr>", { noremap = true })
vim.keymap.set("n", "<leader>T", "<cmd>tab split<cr>", { noremap = true })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<cr>", { noremap = true })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { noremap = true })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { noremap = true })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>", { noremap = true })

-- buffers
vim.keymap.set("n", "<C-,>", "<C-6>", default_opts)

-- quickfix & locations list
vim.keymap.set("n", "<leader>C", "<cmd>copen<cr>", { noremap = true })
vim.keymap.set("n", "<leader>L", "<cmd>lopen<cr>", { noremap = true })
vim.keymap.set("n", "<leader>ca", "<cmd>caddexpr expand('%') . ':' . line('.') . ':' . getline('.')<cr>",
    { noremap = true, silent = true, desc = "Add current line to quickfix list" })

-- resize splits
vim.keymap.set("n", "<C-->", "<C-w>10<", default_opts)
vim.keymap.set("n", "<C-=>", "<C-w>10>", default_opts)
vim.keymap.set("n", "<C-S-=>", "5<C-W>+", default_opts)
vim.keymap.set("n", "<C-S-->", "5<C-W>-", default_opts)

-- misc
vim.keymap.set("n", "<leader><leader>w", ":set wrap!<CR>", default_opts)

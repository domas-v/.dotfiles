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
vim.keymap.set("n", "gl", "$", default_opts)
vim.keymap.set("n", "gh", "|", default_opts)

-- scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", default_opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", default_opts)
vim.keymap.set("n", "<C-S-l>", "zL", default_opts)
vim.keymap.set("n", "<C-S-h>", "zH", default_opts)

-- commands
vim.keymap.set("n", "!", ":!", default_opts)
vim.keymap.set("n", "<C-S-;>", ":lua ", default_opts)

-- lua execution
vim.keymap.set("n", "<leader><leader>E", "<cmd>source %<cr>")
vim.keymap.set("n", "<leader><leader>e", ":.lua<cr>")
vim.keymap.set("v", "<leader><leader>e", ":lua<cr>")

-- saving and closing
vim.keymap.set("n", "<C-q>", "<cmd>close<cr>", default_opts)
vim.keymap.set("n", "<leader>Q", "<cmd>qa<cr>", default_opts)
vim.keymap.set("n", "<leader>W", "<cmd>wa<cr>", default_opts)

-- word wrap
vim.keymap.set("n", "<leader><leader>w", "<cmd>set wrap!<cr>", { noremap = true })

-- undo/redo
vim.keymap.set("n", "U", "<C-r>", { noremap = true })

-- yanking & pasting
vim.keymap.set("n", "Y", "y$", { noremap = true })
vim.keymap.set("x", "p", [["_dP]]) -- paste over visual selection (if doesn't work as expected, rebind to leader-p)

-- pop up movement
vim.keymap.set('i', '<-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
vim.keymap.set('i', '<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })
vim.keymap.set('c', '<C-j>', '<RIGHT>', { noremap = true })
vim.keymap.set('c', '<C-k>', '<LEFT>', { noremap = true })

-- search highlighting
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr>", { noremap = true })

-- tabs
vim.keymap.set("n", "<leader>tt", "<cmd>tab split<cr>", { noremap = true })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<cr>", { noremap = true })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { noremap = true })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { noremap = true })

-- buffers
vim.keymap.set("n", "<leader>X", "<cmd>bd<cr>", default_opts)

-- quickfix
vim.keymap.set("n", "<leader>cj", "<cmd>cnext<cr>", { noremap = true })
vim.keymap.set("n", "<leader>ck", "<cmd>cprevious<cr>", { noremap = true })
vim.keymap.set("n", "<leader>co", "<cmd>copen<cr>", { noremap = true })
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<cr>", { noremap = true })
vim.keymap.set("n", "<leader>cr", ":cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
    { noremap = true })
vim.api.nvim_create_autocmd("FileType", { -- in quickfix list
    pattern = "qf",
    callback = function() vim.keymap.set("n", "q", "<cmd>cclose<cr>", { buffer = true, silent = true }) end
})

-- help
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function() vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true }) end
})

-- windows
vim.keymap.set("n", "<C-h>", "<C-w>h", default_opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", default_opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", default_opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", default_opts)

-- resize splits
vim.keymap.set("n", "<C-,>", "<C-w>10<", default_opts)
vim.keymap.set("n", "<C-.>", "<C-w>10>", default_opts)
vim.keymap.set("n", "<C-;>", "5<C-W>+", default_opts)
vim.keymap.set("n", "<C-'>", "5<C-W>-", default_opts)

local o          = vim.o  -- global options
local wo         = vim.wo -- window local options
local g          = vim.g  -- global variables
local api        = vim.api

-- restore cursor position
api.nvim_create_autocmd(
    { "BufEnter" },
    { pattern = { "*" }, command = 'silent! silent! normal! g`"' }
)

-- line numbers
wo.linebreak     = true
o.nu             = true
o.relativenumber = true

-- tabs and spaces
o.tabstop        = 4
o.expandtab      = true
o.shiftwidth     = 4
o.softtabstop    = 4
o.smartindent    = true

-- remove clutter
o.swapfile       = false
o.writebackup    = false
o.backup         = false
o.shortmess      = o.shortmess .. 'c'

-- appearance
o.splitbelow     = true
o.splitright     = true
o.shiftround     = true
o.wrap           = false
o.cmdheight      = 1
o.showmatch      = true -- show bracket macthing
o.scrolloff      = 8
o.signcolumn     = "yes"
o.termguicolors  = true
o.conceallevel   = 2

-- folds
api.nvim_create_autocmd(
    { "BufEnter" },
    { pattern = { "*" }, command = "normal zx zR" }
) -- because of https://github.com/nvim-telescope/telescope.nvim/issues/699
o.foldlevel  = 1
o.foldmethod = "expr"
o.foldexpr   = "nvim_treesitter#foldexpr()"

-- search
o.ignorecase       = true
o.smartcase        = true
-- o.hlsearch = false
o.incsearch        = true

-- misc
o.mouse            = "a"
o.hidden           = true               -- allow unsaved buffers
o.completeopt      = "menuone,noselect" -- completion type
o.fixendofline     = false              -- don't add new line at end of file

-- performance
o.updatetime       = 100
o.timeoutlen       = 600
o.lazyredraw       = false

-- providers
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.python3_host_prog = "~/.pyenv/shims/python"

local o                  = vim.o  -- global options
local wo                 = vim.wo -- window local options
local g                  = vim.g  -- global variables

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- use system clipboard
o.clipboard              = "unnamedplus"

-- session
o.sessionoptions         = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- line numbers
wo.linebreak             = true
o.nu                     = true
o.relativenumber         = true

-- tabs and spaces
o.expandtab              = true
o.smartindent            = true
o.tabstop                = 4
o.shiftwidth             = 4
o.softtabstop            = 4

-- remove clutter
o.swapfile               = false
o.writebackup            = false
o.backup                 = false
o.shortmess              = o.shortmess .. 'c'

-- appearance
o.splitbelow             = true
o.splitright             = true
o.shiftround             = true
o.wrap                   = false
o.cmdheight              = 1
o.showmatch              = true -- show bracket macthing
o.scrolloff              = 8
o.signcolumn             = "yes"
o.termguicolors          = true
o.conceallevel           = 2

-- folds
vim.o.fillchars          = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn         = '0'
vim.o.foldlevel          = 99
vim.o.foldlevelstart     = 99
vim.o.foldenable         = true


-- search
o.ignorecase           = true
o.smartcase            = true
o.incsearch            = true

-- misc
o.mouse                = "a"
o.hidden               = true               -- allow unsaved buffers
o.completeopt          = "menuone,noselect" -- completion type
o.fixendofline         = false              -- don't add new line at end of file

-- performance
o.updatetime           = 100
o.timeoutlen           = 600
o.lazyredraw           = false

-- providers
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.python3_host_prog    = "~/.pyenv/shims/python"

""""""
" UI "
""""""

" disable vi compatibility
set nocompatible

" automatically load changed files
set autoread

" auto-reload vimrc
autocmd! bufwritepost vimrc source ~/.vim/vimrc

" show the filename in the window titlebar
set title

" set encoding
set encoding=utf-8

" directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backupf

" display incomplete commands at the bottom
set showcmd

" mouse support
set mouse=a

" line numbers
set relativenumber

" highlight cursor line
set cursorline

" ignore whitespace in diff mode
set diffopt+=iwhite

" Be able to arrow key and backspace across newlines
set whichwrap=bs<>[]

" Status bar
set laststatus=2

" remember last cursor position
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\ 	exe "normal g`\"" |
	\ endif

" show '>   ' at the beginning of lines that are automatically wrapped
set showbreak=>\ \ \ 

" enable completion
set ofu=syntaxcomplete#Complete

" make laggy connections work faster
set ttyfast

" set system clipboard
set clipboard=unnamed

" quickly remove search highlights
nmap <ESC> :nohl<CR>

" let vim open up to 100 tabs at once
set tabpagemax=100

" case-insensitive filename completion
set wildignorecase

"""""""""""""
" Searching "
"""""""""""""

set hlsearch "when there is a previous search pattern, highlight all its matches
set incsearch "while typing a search command, show immediately where the so far typed pattern matches
set ignorecase "ignore case in search patterns
set smartcase "override the 'ignorecase' option if the search pattern contains uppercase characters
set gdefault "imply global for new searches

"""""""""""""
" Indenting "
"""""""""""""

" When auto-indenting, use the indenting format of the previous line
set copyindent
" When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'.
" 'tabstop' is used in other places. A <BS> will delete a 'shiftwidth' worth of
" space at the start of the line.
set smarttab
" Copy indent from current line when starting a new line (typing <CR> in Insert
" mode or when using the "o" or "O" command)
set autoindent
" Automatically inserts one extra level of indentation in some cases, and works
" for C-like files
set smartindent

" spaces instead of tabs
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

"""""""""
" Theme "
"""""""""

colorscheme slate
syntax enable
set background=dark

"""""""""
" Keymaps "
"""""""""

vnoremap > >gv
vnoremap < <gv
vnoremap Y y$
vnoremap J <nop>
vnoremap K <nop>

nnoremap k gk
nnoremap j gj
nnoremap 0 _
nnoremap $ g$
nnoremap Y y$

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

nnoremap <C-s> /
nnoremap <C-a> ?

"""""""""""""""""""""
" Language-Specific "
"""""""""""""""""""""

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Add json syntax highlighting
au BufNewFile,BufRead *.json set ft=json syntax=javascript

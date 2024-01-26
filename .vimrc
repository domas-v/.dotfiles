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

" insert mode
inoremap <C-a> <Home>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <C-k> <C-o>D
inoremap <C-u> <C-G>u<C-U>

" move visual selection
vnoremap J :m '>+1<CR>gv=gv 
vnoremap K :m '<-2<CR>gv=gv 
vnoremap H <gv
vnoremap L >gv

" join lines
nnoremap J mzJ`z

" wrapped line movement
nnoremap k gk
nnoremap j gj

" move to first/last characters
nnoremap L g$
nnoremap H _
nnoremap gl $
nnoremap gh \|

" scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap T gg

" execute bash command
nnoremap ! :!

" closing vim
nnoremap <C-q> :close<CR>
nnoremap zq :wqa!<CR>

" word wrap
nnoremap <C-w><C-w> :set wrap!<CR>

" undo/redo
nnoremap U <C-r>

" yanking & pasting
vnoremap <space>y "+y
nnoremap <space>y "+y
nnoremap <space>Y "+Y
nnoremap Y y$
xnoremap p "_dP

" search and replace
nnoremap <RETURN> :nohlsearch<CR>
nnoremap <C-s> /
nnoremap <C-a> ?
nnoremap <space>r :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
vnoremap <space>r :s/
nnoremap <space>R :%s/

" tabs
" nnoremap <space>t :tab split<CR>
nnoremap <space>t :tabnew<CR>
nnoremap <space>x :tabclose<CR>

"""""""""""""""""""""
" Language-Specific "
"""""""""""""""""""""

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Add json syntax highlighting
au BufNewFile,BufRead *.json set ft=json syntax=javascript

execute pathogen#infect()
syntax on

" X11 has two clipboards. "*" and "+". Star is last selected text, paste with
" middle click. Plus is the last ctrl-c test. Paste with ctrl-v. 
" Vim calls these unnamedplus and unnamed. This item makes vim use the start
" keyboard when yanking text if no other register is specified. This is 
" especially useful when you forward you X11 session and ssh into a remote host
" because it then yanks text to your local hosts Star clipboard
set clipboard="unnamed"

filetype on
filetype plugin on
" Indent lines as per indent expressions for their file type
filetype indent on 
" Show git diff in commit message
autocmd FileType gitcommit DiffGitCached | wincmd p

" Auto fold man pages
let g:ft_man_folding_enable = 1

set autoread
set number 
set ruler 
set hlsearch
set showmatch
set incsearch
" Buffer 7 lines before scrolling text
set so=7 
set encoding=utf8
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

set foldmethod=indent
set foldnestmax=10
set foldlevel=2

set tw=120
set ai
set si
set wrap
set showmatch
set mat=2

" Step down wrapped lines not over line
map j gj
map k gk

" Requires taglist vim plugin
nnoremap <silent> <F8> :TlistToggle <CR>
nnoremap <silent> <C-N> :tabe <CR>

" Remove ugly menu bars
set guioptions-=m
set guioptions-=T
set guifont=&guifont

colorscheme Tomorrow-Night-Bright
set background=dark

call plug#begin('~/.nvim/plug')
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/deoplete.nvim', {'do':':UpdateRemotePlugins'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
Plug 'sbdchd/neoformat'
Plug 'davidhalter/jedi-vim'
Plug 'scrooloose/nerdtree'
Plug 'neomake/neomake'
Plug 'terryma/vim-multiple-cursors'
Plug 'machakann/vim-highlightedyank'
Plug 'tmhedberg/SimpylFold'
Plug 'morhetz/gruvbox'
Plug 'icyMind/NeoSolarized'
Plug 'sickill/vim-monokai'
Plug 'nanotech/jellybeans.vim'
Plug 'joshdick/onedark.vim'
Plug 'vim-vdebug/vdebug'
Plug 'itspriddle/vim-shellcheck'
Plug 'vim-scripts/taglist.vim'
call plug#end()
" hack, firacode, sourcecodepro fonts
"https://jdhao.github.io/2018/12/24/centos_nvim_install_use_guide_en/
" deps: python-pynvim python-jedi python-pylint
" ctrl {n,p} for autocompletions


inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
let g:deoplete#enable_at_startup = 1 
" leader (/) cc/cu to comment/uncomment lines
let g:neoformat_basic_format_align = 1 "indent align
let g:neoformat_basic_format_retab = 1 "tab to space
let g:neoformat_basic_format_trim = 1 "trail ws
let g:jedi#completions_enabled = 0
let g:jedi#use_splits_not_buffers = "right" " /d goto def, K def/class doc, /n find symbol usages /r rename symbol
let g:neomake_python_enabled_makers = ['pylint']
call neomake#configure#automake('nrwi',500)

hi HighlightedYankRegion cterm=reverse gui=reverse
"let g:highlightedyank_highlight_duration=1000

set listchars=tab:>-,trail:-

" Requires taglist vim plugin
nnoremap <silent> <F8> :TlistToggle <CR>
nnoremap <silent> <C-N> :tabe <CR>

colorscheme gruvbox
set background=dark

set number

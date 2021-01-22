[[ $- != *i* ]] && return

if [ -d $HOME/bin ];then
    PATH="${PATH}:${HOME}/bin"
fi

# Source code colourizing in less
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS='-R '

# Have vim be the manpager (colouring, super convenient jumping with ctrl-])
# Cannot run these remaps in the .config/nvimpager/init.vim due to precedence of remaps.
# Invocation of nvim via nvimpager uses "-c <remap>" arguments that are applied after loading init.nvim
export MANPAGER="nvimpager \
+':nunmap <buffer> j <bar> :nunmap <buffer> k <bar> :nunmap <buffer> K <bar> :nunmap <buffer> J <bar> :nunmap <buffer> gO' \
+':nnoremap <buffer> j <C-E>' \
+':nnoremap <buffer> k <C-Y>' \
+':nnoremap <buffer> J 10<C-E>' \
+':nnoremap <buffer> K 10<C-Y>' \
+':nnoremap <buffer> <silent> m :call man#show_toc()<CR><C-w>L:vertical res 45<CR><C-w>h' \
+':nnoremap <buffer> q <C-w>b<Cmd>q<CR>' \
+':nnoremap <buffer> Q <C-w>q<CR>'
"
export PAGER="$MANPAGER"

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export HISTIGNORE=""

shopt -s cdspell autocd direxpand dirspell histappend cdable_vars expand_aliases no_empty_cmd_completion 

# use \{diff, grep, ls, ..} to get non aliased cmd when piping to files for text processing (when you dont want cntrl chars)
alias diff='diff --color=auto'
alias grep='grep -E --color=auto' # Always extended!
alias ls='ls --color=auto'
alias pacman='pacman --color=auto'
alias ff='find . -iname '
alias fp='find . -ipath '
alias nv='nvim'
alias cat='ccat'

# Colourize man pager
_man() {
    env \
	LESS_TERMCAP_mb=$(printf "\e[1;31m") \
	LESS_TERMCAP_md=$(printf "\e[1;31m") \
	LESS_TERMCAP_me=$(printf "\e[0m") \
	LESS_TERMCAP_se=$(printf "\e[0m") \
	LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
	LESS_TERMCAP_ue=$(printf "\e[0m") \
	LESS_TERMCAP_us=$(printf "\e[1;32m") \
	man "$@"
}

# Green theme
#man() {
#	env \
#	LESS_TERMCAP_md=$'\e[1;36m' \
#	LESS_TERMCAP_me=$'\e[0m' \
#	LESS_TERMCAP_se=$'\e[0m' \
#	LESS_TERMCAP_so=$'\e[1;40;92m' \
#	LESS_TERMCAP_ue=$'\e[0m' \
#	LESS_TERMCAP_us=$'\e[1;32m' \
#	man "$@"
#}


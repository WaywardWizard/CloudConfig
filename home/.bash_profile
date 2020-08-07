[[ $- != *i* ]] && return
if [ -d $HOME/bin ];then
    PATH="${PATH}:${HOME}/bin"
fi

# Ignore and erase duplicates in history
declare -A RC

# bashrc meta settings
# 31/91 red 32/92 green 33/93 yellow 34/94 blue 35/95 magenta 36/96 cyan
declare -A RC
RC[dir]="33"
RC[time]="35"
RC[rootUser]="91"
RC[user]="92"
RC[host]="34"
RC[success]="1"
RC[fail]="2"

# Source code colourizing in less
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS='-R '

# Have vim be the manpager (colouring, super convenient jumping with ctrl-])
#export PAGER="nvimpager +':norm gO'"

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

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export HISTIGNORE=""

shopt -s cdspell autocd direxpand dirspell dotglob histappend cdable_vars expand_aliases no_empty_cmd_completion 

# Resize window after each command
#set shopt checkwinsize
shopt -s no_empty_cmd_completion

# use \{diff, grep, ls, ..} to get non aliased cmd when piping to files for text processing (when you dont want cntrl chars)
alias diff='diff --color=auto'
alias grep='grep -E --color=auto' # Always extended!
alias ls='ls --color=auto'
alias pacman='pacman --color=auto'
alias ff='find . -iname '
alias fp='find . -ipath '
alias nv='nvim'
alias cat='ccat'

alias phpx='XDEBUG_CONFIG="!" php'
alias phpp='php -d xdebug.profiler_enable=1 '


# Command substitution is delayed to exec 
PS1=" \$(lastCommandColourCoded) \[\e[1;${RC[time]}m\]\A\[\e[0m\] [\$(userColour)\u\[\e[0m\]|\$(hostColour)\h\[\e[0m\] \[\e[1;${RC[dir]}m\]\w\[\e[0m\]]$ "

userColour() {
	if [ "$EUID" != "0" ]
	then
		printf "\001\e[1m\e[${RC[user]}m\002"
	else
		printf "\001\e[${$RC[rootUser]}m]\002"
	fi
}

hostColour() { printf "\001\e[${RC[host]}m\002"; }

lastCommandColourCoded() {
	RET=$?
	if (( $RET )) 
	then
		# Two blanks either side for consistent width
		printf "\001$(tput setaf ${RC[success]})\002$(printf "%3s" "\xF0\x9F\x91\xBD")\001$(tput sgr0)\002"
	else 
		printf "\001$(tput setaf ${RC[fail]})\002$(printf "%3s" "\xe2\x9c\x93")\001$(tput sgr0)\002"
	fi
}
	

# Colourize man pager
man() {
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


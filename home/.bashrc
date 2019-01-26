# Ignore and erase duplicates in history
declare -A RC

# bashrc meta settings
# 31/91 red 32/92 green 33/93 yellow 34/94 blue 35/95 magenta 36/96 cyan
RC[dir]="33"
RC[time]="35"
RC[rootUser]="91"
RC[user]="92"
RC[host]="34"
RC[success]="1"
RC[fail]="2"


export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export HISTIGNORE=""
set shopt histappend # append to history dont discard

set shopt cdspell autocd
set shopt direxpand dirspell

# Resize window after each command
set shopt checkwinsize
set shopt no_empty_cmd_completion

alias diff='diff --color=auto '
alias grep='grep --color=auto '
alias ls='ls --color=auto '

# Command substitution is delayed to exec 
PS1=' $(lastCommandColourCoded) \[\e[1;${RC[time]}m\]\A\[\e[0m\] [$(userColour)\u\[\e[0m\]|$(hostColour)\h\[\e[0m\] \[\e[1;${RC[dir]}m\]\w\[\e[0m\]]$ '

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
	if (( $? )) 
	then
		# Two blanks either side for consistent width
		printf "\001$(tput setaf ${RC[success]})\002$(printf "%3d" "$RET")\001$(tput sgr0)\002"
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


# Source code colourizing in less
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS='-R '

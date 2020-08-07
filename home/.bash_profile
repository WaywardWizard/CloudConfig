[[ $- != *i* ]] && return

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

# Command substitution is delayed to exec 
PS1=" \$(_lastCommandColourCoded) \[\e[1;${RC[time]}m\]\A\[\e[0m\] [\$(_userColour)\u\[\e[0m\]|\$(_hostColour)\h\[\e[0m\] \[\e[1;${RC[dir]}m\]\w\[\e[0m\]]$ "

_userColour() {
	if [ "$EUID" != "0" ]
	then
		printf "\001\e[1m\e[${RC[user]}m\002"
	else
		printf "\001\e[1m\e${$RC[rootUser]}m]\002"
	fi
}

_hostColour() { printf "\001\e[${RC[host]}m\002"; }

_lastCommandColourCoded() {
	RET=$?
	if (( $RET )) 
	then
		# Two blanks either side for consistent width
		printf "\001$(tput setaf ${RC[success]})\002$(printf "%3s" "\xF0\x9F\x91\xBD")\001$(tput sgr0)\002"
	else 
		printf "\001$(tput setaf ${RC[fail]})\002$(printf "%3s" "\xe2\x9c\x93")\001$(tput sgr0)\002"
	fi
}

alias phpx='XDEBUG_CONFIG="!" php'
alias phpp='php -d xdebug.profiler_enable=1 '

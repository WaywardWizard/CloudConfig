[[ $- != *i* ]] && return

alias phpx='XDEBUG_CONFIG="!" php'
alias phpp='php -d xdebug.profiler_enable=1 '

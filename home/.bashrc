# Ignore and erase duplicates in history
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export HISTIGNORE="ls*:cd*:"
set shopt histappend # append to history dont discard

set shopt cdspell autocd
set shopt direxpand dirspell

# Resize window after each command
set shopt checkwinsize
set shopt no_empty_cmd_completion

alias ls='ls --color=auto'

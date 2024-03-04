
autoload -Uz compinit promptinit
compinit
promptinit

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v

export EDITOR="nvim"

eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

alias cd=z
alias ll="ls -l"

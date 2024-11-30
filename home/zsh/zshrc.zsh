# autoload -U colors && colors

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# set some options
setopt autocd extendedglob nomatch
unsetopt beep notify
bindkey -e # emacs bindings in terminal

# enable completion
autoload -Uz compinit; compinit

# aliases
alias \
    cp="cp -iv" \
    mv="mv -iv" \
    rm="rm -vI" \
    ls="eza --icons" \
    grep="grep --color=auto" \
    e="hx" \
    z="zathura" \
    btw="fastfetch"

# system plugins
eval "$(zoxide init zsh --cmd cd)"

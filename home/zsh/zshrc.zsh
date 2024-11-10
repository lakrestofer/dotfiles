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

# Load plugin manager zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# aliases
alias \
    cp="cp -iv" \
    mv="mv -iv" \
    rm="rm -vI" \
    ls="eza --icons" \
    grep="grep --color=auto" \
    e="hx" \
    z="zathura"


# system plugins
eval "$(zoxide init zsh --cmd cd)"

# plugins loaded with zinit
zinit light zsh-users/zsh-autosuggestions
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship
# zinit ice pick"async.zsh" src"pure.zsh"
# zinit light sindresorhus/pure # better promt
zinit wait lucid light-mode for lukechilds/zsh-nvm # node version manager
zinit light zsh-users/zsh-syntax-highlighting

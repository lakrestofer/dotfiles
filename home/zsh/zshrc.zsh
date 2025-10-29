# autoload -U colors && colors

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# compile zsh files into wordcode
function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

#does the plugin directory exist?
if [[ ! -e ~/.zshplugins ]]; then
    mkdir ~/.zshplugins
fi

# Clone and compile to wordcode missing plugins.
if [[ ! -e ~/.zshplugins/zsh-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zshplugins/zsh-syntax-highlighting
  zcompile-many ~/.zshplugins/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
if [[ ! -e ~/.zshplugins/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.zshplugins/zsh-autosuggestions
  zcompile-many ~/.zshplugins/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
if [[ ! -e ~/.zshplugins/zsh-fzf-history-search ]]; then
  git clone --depth=1 https://github.com/joshskidmore/zsh-fzf-history-search ~/.zshplugins/zsh-fzf-history-search
  zcompile-many ~/.zshplugins/zsh-fzf-history-search/zsh-fzf-history-search.zsh
fi
if [[ ! -e ~/.zshplugins/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zshplugins/powerlevel10k
  make -C ~/.zshplugins/powerlevel10k pkg
fi

# Activate Powerlevel10k Instant Prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit && compinit
[[ ~/.zcompdump.zwc -nt ~/.zcompdump ]] || zcompile-many ~/.zcompdump
unfunction zcompile-many

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

setopt autocd extendedglob nomatch
unsetopt beep notify
bindkey -e # emacs bindings in terminal

# aliases
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vI"
alias ls="eza -l"
alias grep="grep --color=auto"
alias e="hx"
alias z="zathura"
alias btw="fastfetch"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias o="xdg-open"

# some settings
export FZF_DEFAULT_OPTS='
--style=minimal
--color=16
'
    
# system plugins
source ~/.zshplugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zshplugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zshplugins/zsh-fzf-history-search/zsh-fzf-history-search.zsh
source ~/.zshplugins/powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh
eval "$(zoxide init zsh --cmd cd)"
eval "$(direnv hook zsh)"

source ~/keys.sh

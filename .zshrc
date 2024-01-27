autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch
unsetopt beep notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/fincei/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias \
    cp="cp -iv" \
    mv="mv -iv" \
    rm="rm -vI" \
    ls="exa --icons" \
    grep="grep --color=auto" \
    e="helix" \
    p="sudo pacman" \
    config="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"\
    ga="git add"\
    gc="git commit"\
    gp="git push"\
    z="zathura"

eval "$(zoxide init zsh --cmd cd)"

#[ -s /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

# Load some zsh plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/fincei/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/fincei/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/fincei/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/fincei/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
if (( $+commands[conda] )); then # only run conda deactivate if conda is installed it exists
    conda deactivate
fi

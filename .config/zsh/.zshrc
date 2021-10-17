setopt extendedglob
setopt histignorealldups
setopt COMPLETE_ALIASES

# Set vi keymap
bindkey -v
export KEYTIMEOUT=1

PS1='%F{green}%B%n@%M%b%f:%F{blue}%B%~%b%f%# '
RPS1='[%F{yellow}%?%f]'

# Enable command completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# Source all files under zsh/source directory
if [[ -r "$ZDOTDIR/source" ]]; then
    for file in $ZDOTDIR/source/*; do
        [[ -r "$file" ]] && source "$file"
    done
fi

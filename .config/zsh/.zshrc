setopt extendedglob
setopt histignorealldups
setopt COMPLETE_ALIASES

KEYTIMEOUT=15
bindkey -v # Set vi keymap
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^?' backward-delete-char
bindkey '^P' up-history
bindkey '^N' down-history

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

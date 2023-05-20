setopt extendedglob
setopt histignorealldups

KEYTIMEOUT=15
bindkey -v # Set vi keymap
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^?' backward-delete-char  # Backspace
bindkey -M viins '^H' backward-kill-word    # Ctrl-Backspace
bindkey '^P' up-history                     # Ctrl-p
bindkey '^N' down-history                   # Ctrl-n

() {
  # Add local completions to fpath
  local completion="$ZDOTDIR/completion"
  [[ ! -r "$completion" ]] && return
  (( $fpath[(Ie)$completion] )) || fpath+=("$completion")
}

# Enable command completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# Source all files under zsh/source directory
if [[ -r "$ZDOTDIR/source" ]]; then
  for file in "$ZDOTDIR/source"/*; do
    [[ -r "$file" ]] && source "$file"
  done
fi

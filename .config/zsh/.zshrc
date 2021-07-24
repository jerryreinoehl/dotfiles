setopt extendedglob
setopt COMPLETE_ALIASES

# Set vi keymap
bindkey -v
export KEYTIMEOUT=1

PS1='%F{green}%B%n@%M%b%f:%F{blue}%B%~%b%f%# '
RPS1='[%F{yellow}%?%f]'

# Source aliases
[[ -r "$XDG_CONFIG_HOME/aliases" ]] && . "$XDG_CONFIG_HOME/aliases"

# Enable command completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

function source_if_exists() {
    [[ -r "$1" ]] && source "$1"
}

source_if_exists /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_exists /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source_if_exists ~/dev/cd_history/cd_history.sh

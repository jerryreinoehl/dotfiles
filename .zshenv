# =============================================================================
# .zshenv
# =============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

export EDITOR='vim'
export VISUAL='vim'

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

export ANSIBLE_STDOUT_CALLBACK='debug'

export VIM_TMUX_NAV=1

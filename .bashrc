# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export EDITOR=vim

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Bash checks the window size after each external (non-builtin) command and, if
# necessary, updates the values of LINES and COLUMNS.
shopt -s checkwinsize

# The pattern ** used in a pathname expansion context will match all files and
# zero or more directories and subdirectories. If the pattern is followed by a
# /, only directories and subdirectories match.
shopt -s globstar

# The history list is appended to the file named by the value of the HISTFILE
# variable when the shell exits, rather than overwriting the file.
shopt -s histappend

# Bash includes filenames beginning with a `.' in the results of pathname
# expansion. The filenames ``.'' and ``..'' must always be matched explicitly,
# even if dotglob is set.
shopt -s dotglob

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ============================================================================
# Prompts
# ============================================================================

PS2='\[\e[1;32m\]> \[\e[0m\]'

PROMPT_COMMAND=__prompt_command

__pscwd_mode=full
__toggle_pscwd_mode_key='\ew' # Alt-w

function __prompt_command() {
    # capture PIPESTATUS before calling any other function
    __pipestatus="${PIPESTATUS[@]}"

    __set_pserror

    PS1="\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\%w\[\033[0m\]\%e\\$ "
    __replace_prompt_vars PS1
}

function __set_pserror() {
    if [[ "$__pipestatus" =~ ^0( 0)*$ ]]; then
        __pserror=""
    else
        __pserror="\[\033[1;31m\] [$__pipestatus]\[\033[0m\]"
    fi
}

#   $1 - Return var.
function __set_pscwd() {
    local -n _ret="$1"
    local result=

    case "$__pscwd_mode" in
        abbreviated) __pscwd_abbreviated result;;
        full)        __pscwd_full result;;
        short)       __pscwd_short result;;
    esac
    _ret="$result"
}

#   $1 - Return var.
function __pscwd_abbreviated() {
    local -n _ret="$1"
    local IFS='/'
    local cwd=($(dirs +0))
    local last="${cwd[-1]}"

    __truncate_strings cwd
    cwd[-1]="$last"
    _ret="${cwd[*]}"
}

#   $1 - Return var.
function __pscwd_full() {
    local -n _ret="$1"
    _ret='\w'
}

#   $1 - Return var.
function __pscwd_short() {
    local -n _ret="$1"
    _ret='\W'
}

function __toggle_pscwd_mode() {
    case "$__pscwd_mode" in
        abbreviated) __pscwd_mode=full;;
        full)        __pscwd_mode=short;;
        short)       __pscwd_mode=abbreviated;;
    esac
}

bind -r "${__toggle_pscwd_mode_key}"
bind "\"${__toggle_pscwd_mode_key}\":\"\C-e \C-u \x20 __toggle_pscwd_mode_key_binding \C-j\""

function __toggle_pscwd_mode_key_binding() {
    __toggle_pscwd_mode   # toggle PS1 CWD mode
    tput cuu1             # move up a line
    tput el               # clear line
    return $__pipestatus  # maintain PIPESTATUS
}

# Replaces special character sequences with their decoded values.
#   $1 - String on which replacements should take place.
function __replace_prompt_vars() {
    local -n str="$1"

    local pscwd=
    __set_pscwd pscwd
    str="${str//\\%w/$pscwd}"

    str="${str//\\%e/$__pserror}"
}

# Truncates all strings of an array to the first character.
#   $1 - Name of array of strings.
function __truncate_strings() {
    local -n array="$1"
    local len="${#array[@]}"
    for (( i=0; i<$len; i++)); do
        array[$i]="${array[$i]:0:1}"
    done
}

# ============================================================================

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS2='\[\e[1;32m\]> \[\e[0m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#=============================================================================
# Aliases
#=============================================================================

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --group-directories-first --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -ACF'
alias l='ls -ACF'
#alias l.='ls -A | egrep "^(.*\[.+)?\.(.*\[.+)?"'

# navigation
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias :q='exit'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# distro-specific aliases
distro=$(hostnamectl | sed -n -e '/Operating/s/.*:[[:space:]]*\(.*\)/\L\1/p')

case $distro in
*ubuntu*)
    alias update='sudo apt -y update && sudo apt -y upgrade && sudo apt moo'
    ;;
esac
unset distro

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

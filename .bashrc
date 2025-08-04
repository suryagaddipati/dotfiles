# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Lazy-load lesspipe
_lesspipe() {
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
}

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

# Lazy-load dircolors and set color aliases
_setup_colors() {
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
}
# Set basic color aliases immediately (without eval)
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# git alias
alias g='git'

# tmux shortcuts
alias t='tmux_smart_session'

# git auto-commit alias
alias git-autocommit="$HOME/code/dotfiles/git-auto-commit.sh"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Lazy-load bash completion for faster startup
_enable_completion() {
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
    fi
}


# tmux smart session function
tmux_smart_session() {
    if [ $# -eq 0 ]; then
        # No arguments - attach to existing session or create default
        if tmux has-session 2>/dev/null; then
            tmux attach
        else
            tmux new-session -s main
        fi
    else
        # Session name provided
        session_name="$1"
        if tmux has-session -t "$session_name" 2>/dev/null; then
            tmux attach -t "$session_name"
        else
            tmux new-session -s "$session_name"
        fi
    fi
}

# Lazy-load SDKMAN for faster startup
sdk() {
    unset -f sdk
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk "$@"
}
. "$HOME/.cargo/env"

# Source private bash configuration if it exists
if [ -f ~/.bashrc_private ]; then
    . ~/.bashrc_private
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add ~/.local/bin to PATH for user-installed tools (including just)
export PATH="$HOME/.local/bin:$PATH"

# Add git-commands to PATH for custom git subcommands
export PATH="$HOME/code/dotfiles/git-commands:$PATH"

# Set vi mode
set -o vi

# Set default editor to neovim
export EDITOR="nvim"
export VISUAL="nvim"

# Remap Caps Lock to Ctrl (lazy-loaded for X11 sessions)
caps_ctrl() {
    setxkbmap -option caps:ctrl_modifier 2>/dev/null || true
}
grp() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: grp <pattern> <ext1> [<ext2> ...]"
    echo "Example: grp TODO js ts py"
    return 1
  fi

  local pattern="$1"
  shift

  # Build regex: \.js$|\.ts$|\.py$
  local ext_regex=$(printf "\\.%s$|" "$@" | sed 's/|$//')

  # Use git to list all unignored files, filter by extension, and grep
  git ls-files --cached --others --exclude-standard \
    | grep -E "$ext_regex" \
    | xargs -d '\n' grep --color=auto -n "$pattern" 2>/dev/null
}

# Uncomment all lines in /etc/hosts
focus() {
  sudo sed -i 's/^#\(.*\)/\1/' /etc/hosts
  echo "All commented lines in /etc/hosts have been uncommented"
}


# Initialize mise (cross-platform)
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi

# opencode (cross-platform)
if [ -d "$HOME/.opencode/bin" ]; then
    export PATH=$HOME/.opencode/bin:$PATH
fi

export PATH=$PATH:/opt/homebrew/bin

# Claude CLI alias (cross-platform)
if [ -f "$HOME/.claude/local/claude" ]; then
    alias claude="$HOME/.claude/local/claude"
fi

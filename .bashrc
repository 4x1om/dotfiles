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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Used in WSL 2 to display graphical interfaces.
# Src=https://stackoverflow.com/questions/43397162/show-matplotlib-plots-and-other-gui-in-ubuntu-wsl1-wsl2
# export DISPLAY=`grep -oP "(?<=nameserver ).+" /etc/resolv.conf`:0.0

# Vim plugins
export VIMPLUG=~/.vim/pack/plugins/start

# SDCV dictionaries directory
export SDCV=~/.stardict/dic

###############
### SOURCES ###
###############

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

# Source rust dotfile only if cargo is installed
if command -v cargo >/dev/null 2>&1; then
	. "$HOME/.cargo/env"
fi

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

###############
### ALIASES ###
###############

#!/bin/bash

shopt -s expand_aliases

# NOTE: Putting a backslash before the command name disables any aliases.
# See https://stackoverflow.com/a/7716048

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='\ls -F --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# -R: Allow ANSI coloring
alias less='less -R'

# -A: List all (hidden files)
alias la='ls -A'
# -l: Long listing format
alias ll='ls -Al'
# -C: List entries by columns
alias l='ls -C'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

alias cp='cp -r'

# System updates
alias update='sudo apt update && sudo apt upgrade'

# Networking
alias myip='curl ifconfig.me'

# trash-cli
if command -v trash-put >/dev/null 2>&1; then
	echo '`rm` is now an alias of `trash-put`.'
	alias rm="trash-put"
	# "recover"
	alias restore='trash-restore'
	alias list='trash-list'
	alias empty='trash-empty'
else
	alias rm='rm -r'
fi

# ssh commands
alias scp='scp -r'
alias tunnel3000='ssh -o ServerAliveInterval=60 -L 3000:localhost:3000'

# python commands
alias python='python3'
alias p3='python3'
alias p3i="python3 -i"

# ROT13
# Usage: echo plaintext | rot13
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

#################
### FUNCTIONS ###
#################

# Echo $PATH, separated by \n
path() {
	echo $PATH | sed "s/:/\n/g"
}

# `cd` then `ls`. If called without arguments, it equals a raw `ls`.
cl() {
	cd "$1" && ls
}

# `mkdir` then `cl`.
mkcl() {
	mkdir "$1" && ls "$1"
}

# `cd` then `la`.
ca() {
	cd "$1" && ls -A
}

# Create and go to a temporary directory.
tmp() {
	cd $(mktemp -d)
}

# Duplicate file or directory and add a counter at the end.
# If called with 2 parameters, it's equivalent to cp -r.
dupe() {
	if [ "$#" -lt 1 ]; then
		echo "Usage: dupe <path> [<target>]"
		return 1
	fi

	path="$1"
	if [ ! -e "$path" ]; then
		echo "dupe: $path not found"
		return 1
	fi

	if [ "$#" -ge 2 ]; then
		path_duped="$2"
	else
		counter=1
		while [ -e "${path}_$counter" ]; do
			counter=$((counter + 1))
		done
		path_duped="${path}_$counter"
	fi

	cp -r "$path" "$path_duped" && echo "Duplicated $path -> $path_duped"
}

# Look up in sdcv
# Dependency: apt sdcv
see() {
	query="$*"
	# The sed command adds 4 spaces before each line
	sdcv -n --color "$query" -u "Webster's Revised Unabridged Dictionary (1913)" \
		-u "Collins Cobuild English Dictionary" \
		-u "WordNet" | sed "s/^/    /" | less -R
}

# Check synonyms
syn() {
	query="$*"
	# The sed command adds 4 spaces before each line
	sdcv -n --color "$query" -u "Moby Thesaurus II" | sed "s/^/    /" | less -R
}

# Search on jisho.org
# Dependency: npm jisho-cli
# miru() {
# 	query="$*"
# 	jisho-cli -c always -r "$query" | less -R
# }

############
### PATH ###
############

# This is for pip's global packages I think?
export PATH=/home/fuko/.local/bin:$PATH
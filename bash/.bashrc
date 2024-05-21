# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Helpers
# safe source
function safe_source {
  [ -f "$1" ] && source "$1"
}

# check if program is available
function has_program {
  hash $1 2>/dev/null
}

function is_vim_running {
  jobs | grep -o 'vim' &> /dev/null
}

#function is_direnv_dir {
#  [[ -n "${DIRENV_DIR}" ]]
#}

# Disable console start/stop: makes ^S and ^Q go through
stty -ixon

## Load direnv
# has_program direnv && eval "$(direnv hook bash)"

## Utilities


export CC=clang
export CXX=clang++
# export CFLAGS='-Wall -Werror -Wextra'

# asm: print asm to stdout
function asm() {
    ${CC} ${CFLAGS} -S "$1" -o /dev/stdout | grep -v '\.'
        }

# ccc: cc with filename
function ccc() {
    file=$(basename "$1" .c)
        ${CC} -o "$file" "$1"
        }

function cxx() {
    file=$(basename "$1" .cpp)
        ${CXX} -o "$file" "$1"
        }

# ccdb: cc with filename for debugging
function ccdb() {
    file=$(basename "$1" .c)
        gcc -g -o "$file" "$1" -lm
        }


# go back n directories
function b {
    str=""
    count=0
    while [ "$count" -lt "$1" ];
    do
        str=$str"../"
        let count=count+1
    done
    cd $str
}

# extract files: depends on zip, unrar and p7zip
function ex {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via ex()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# mkdir && cd
function mkcd {
  mkdir -p "$1" && cd "$1";
}

# repeat command
function repeat() {
  number=$1
  shift
  for n in $(seq $number); do
    if ! $@; then
      echo "Sorry, something failed!"
      return 1
    fi
  done
  return 0
}

# find and edit, replace vim with editor
function find_and_edit () {
  if test -d .git
  then
    SOURCE="$(git ls-files)"
  else
    SOURCE="$(find . -type f)"
  fi
  files="$(fzf --preview='bat --color=always --paging=never --style=changes {} | head -$FZF_PREVIEW_LINES' --select-1 --multi --query="$@" <<< "$SOURCE")"
  if [[ "$?" != "0" ]]
  then
    return 1
  fi
  vim $files
}


# envs.sh file service
function mirror() {
    curl -F "url=$1" https://envs.sh/
}
function upload() {
    if [[ -z $1 ]]; then a="file=@-"; else a="file=@$1"; fi
    curl -F $a https://envs.sh/
}
dfupload() {
    if [[ -z $1 ]]; then a="file=@-"; else a="file=@$1"; fi
    scp $1 getz@smocke.df.lth.se:~/UPLOADS/
}

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
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1)/'"
# local_ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2)
local_ip=$(hostname)


PS1='\e[${USER_COLOR}m[${USER}@${local_ip}]\e[1;35m~\e[1;34m[$PWD]$(printf "%$(($COLUMNS - 9 - ${#USER} - ${#HOSTNAME} - ${#PWD} - 8))s")\e[1;33m\e[m\n$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias cc='cc ${CFLAGS}'

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
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

if [ -r /usr/pkg/share/bash-completion/bash_completion ]; then
    . /usr/pkg/share/bash-completion/bash_completion
fi

# If there are multiple matches for completion, Tab should cycle through them
bind 'TAB:menu-complete'
# And Shift-Tab should cycle backwards
bind '"\e[Z": menu-complete-backward'

# Display a list of the matching files
bind "set show-all-if-ambiguous on"

# Perform partial (common) completion on the first Tab press, only start
# cycling full results on the second Tab press (from bash version 5)
bind "set menu-complete-display-prefix on"

# display one column with matches
#bind "set completion-display-width 1"
bind "set colored-completion-prefix on"
bind "set colored-stats on"


## includes ##
if [ -x "$(command -v fzf)"  ]
then
    source ~/.config/fzf/key-bindings.bash
fi

#[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# tat: tmux attach
function tat {
  name=$(basename `pwd` | sed -e 's/\.//g')

  if tmux ls 2>&1 | grep "$name"; then
    tmux attach -t "$name"
  #elif [ -f .envrc ]; then
  #  direnv exec / tmux new-session -s "$name"
  else
    tmux new-session -s "$name"
  fi
}

bind 'set completion-ignore-case on'
. "$HOME/.cargo/env"

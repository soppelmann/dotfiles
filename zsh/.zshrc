# profiling
#zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.


if [[ $OSTYPE = darwin* ]]; then
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
    #
    #Add to path in /etc/paths
    export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    #Matlab
    alias matlab='/Applications/MATLAB_R2024b.app/bin/matlab -nodesktop -nosplash $*'
    source ~/.config/zsh/plugins/nix-shell/nix-shell.plugin.zsh

    enablemamba() {
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
                . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
            else
                export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<
    }


    #C++ clang path
    export CC=/usr/bin/clang
    export CXX=/usr/bin/clang++

    # ruby enable
    eval "$(rbenv init - zsh)"

    # opam configuration
    [[ ! -r /Users/getz/.opam/opam-init/init.zsh ]] || source /Users/getz/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

    #p10k
    source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
    source ~/.config/powerlevel10k/p10k.zsh

    #nix
    source ~/.config/zsh/plugins/nix-shell.plugin.zsh

    #profiling
    #zprof

    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
elif then
    source ~/.config/zsh/prompt.zsh
fi


#Fix TERM
export TERM=xterm-256color

# environment variables
export BLOCKSIZE=1k
export CVS_RSH=/usr/bin/ssh
export IRCNAME="*Unknown*"
export LESS="-iR"
export MYSQL_HISTFILE=/dev/null
export NO_COLOR=1
#export SSH_ASKPASS_REQUIRE=prefer

# let control+w only delete one directory of a path, not the whole word
export WORDCHARS='*?_[]~=&;!#$%^(){}'

# on non-interactive shells, just exit here to speed things up
if [[ ! -o interactive ]]; then
   return
fi

# zsh will try to use vi key bindings because of the vi $EDITOR, but i want
# emacs style for control+a/e, etc.
bindkey -e

# enable direnv
if [[ -x direnv ]]; then
   eval "$(direnv hook zsh)"
fi

export DIRENV_LOG_FORMAT=

#_direnv_hook() {
#  eval "$(direnv export zsh 2> >( egrep -v -e '^direnv: (loading|export|unloading)' ))"
#};

# i'm too lazy to type these out
# alias emacs='emacs -nw'
alias btop='bpytop'
alias calc='perl -pe "print eval(\$_) . chr(10);"'
alias cdu="cvs -q diff -upRN"
alias cp="cp -i"
alias gst="git status"
alias jobs="jobs -p"
alias k9="kill -9 %1"
alias ll="ls -alF"
alias ls="ls -aF --color"
alias mv="mv -i"
alias rm="rm -i"
alias offline_mutt="mutt -R -F ~/.muttrc.offline"
alias ph="ps auwwx | head"
alias pg="ps auwwx | grep -i -e ^USER -e "
alias publicip="curl -s http://ifconfig.me "
alias rg="rg --color=never -N -z"
alias shitssh='ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -c 3des-cbc,aes256-ctr'

# when i say vi i mean vim (if it's installed)
if [ -x "`which vim`" ]; then
   alias vi="vim"
   alias view="vim -R"
   export EDITOR=`which vim`
else
   export EDITOR=/usr/bin/vi
fi

# options
setopt noclobber                     # halp me
setopt nohup                         # don't kill things when i logout
setopt print_exit_value              # i want to know if something went wrong
HISTFILE=~/.HISTFILE
HISTSIZE=100000000
SAVEHIST=100000000
HISTSIZE=100000000
TMOUT=0                              # don't auto logout

# i am frequently too quick to logout with control+d twice (one to exit ssh,
# another to close the terminal) and will miss the 'you have suspended jobs'
# message, so hitting it twice still logs me out.  prevent that by not sending
# eof on control+d but manually bind to it and run a function that exits.
setopt ignore_eof
_block_quick_bail() {
   _sj=`jobs -sp`
   if [[ $_sj == "" ]]; then
      exit
   else
      _sj=$'\n'${_sj}
      zle -M "zsh: you have suspended jobs:${_sj}"
   fi
}
zle -N _block_quick_bail
bindkey '^d' _block_quick_bail

# show all logins and such
watch=all
WATCHFMT="%B%n%b %a %l at %@"

# etc
limit coredumpsize 0                 # don't know why you'd want anything else
umask 022                            # be nice

alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1)/'"

# https://superuser.com/questions/458906
__git_files () {
    _wanted files expl 'local files' _files
}

# envs.sh file service
mirror() {
    curl -F "url=$1" https://envs.sh/
}
upload() {
    if [[ -z $1 ]]; then a="file=@-"; else a="file=@$1"; fi
    curl -F $a https://envs.sh/
}

dfupload() {
    if [[ -z $1 ]]; then a="file=@-"; else a="file=@$1"; fi
    scp $1 getz@iblis.df.lth.se:~/UPLOADS/
}

week() {
    curl --silent https://vecka.nu 2>&1 | grep 'week =' | sed 's/[^0-9]//g'
}

# os-specific tweaks

export STORE_LASTDIR=1

if [ "$STORE_LASTDIR" = "1" ]; then
   # now go to the last dir that was there
   chpwd() {
      pwd >! ~/.zsh.lastdir
   }

   if [ -f ~/.zsh.lastdir ]; then
      if [ -d "`cat ~/.zsh.lastdir`" ]; then
         cd "`cat ~/.zsh.lastdir`"
      else
         rm -f ~/.zsh.lastdir
      fi
   fi
fi

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Plugins
source ~/.config/zsh/plugins/zsh-autosuggestions.zsh
#source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/completion.zsh
source ~/.config/zsh/plugins/key-bindings.zsh
source ~/.config/zsh/plugins/sudo.zsh

#case insensitive completion
#zstyle ':completion:*' menu select matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

#zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

autoload -Uz compinit && compinit

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# export CFLAGS='-Wall -Werror -Wextra'
# asm: print asm to stdout
function asm() {
    ${CC} ${CFLAGS} -O3 -S "$1" -o /dev/stdout | grep -v '\.'
        }

# ccc: cc with filename
function ccc() {
    file=$(basename "$1" .c)
        ${CC} ${CFLAGS} -o "$file" "$1"
        }

# ccdb: cc with filename for debugging
function ccdb() {
    file=$(basename "$1" .c)
        ${CC} -g -o "$file" "$1" -lm
        }

function cxx() {
    file=$(basename "$1" .cpp)
        ${CXX} -o "$file" "$1"
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
        *.tar.bz2)   tar xvf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.tar.xz)    tar xvf $1     ;;
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
  # emacsclient -c $files
  vim $files
}


if [ -n "$INSIDE_EMACS" ]; then
#  chpwd() { print -P "\033AnSiTc %d" }
#  print -P "\033AnSiTu %n"
#  print -P "\033AnSiTc %d"
fi

if [ -n "$INSIDE_EMACS" ]; then
    function em() {
        emacsclient -n "$1"
    }
fi

# tat: tmux attach
function tat {
  name=$(basename `pwd` | sed -e 's/\.//g')

  if tmux ls 2>&1 | grep "$name"; then
    tmux attach -t "$name"
  elif [ -f .envrc ]; then
    direnv exec / tmux new-session -s "$name"
  else
    tmux new-session -s "$name"
  fi
}

alias fp='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'

# setup ctrl + arrows
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

export UVM_HOME="/Users/getz/Developer/UVM"
export PATH="/Users/getz/.qlot/bin:$PATH"

# [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
  # source "$EAT_SHELL_INTEGRATION_DIR/zsh"

export ELECTRON_OZONE_PLATFORM_HINT=wayland


if [ -f ~/.zsh.tailscale ]; then
    source ~/.zsh.tailscale
fi


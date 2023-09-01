# profiling
#zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


#
#Add to path in /etc/paths
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

#Fix TERM
export TERM=xterm-256color

#C++ clang path
export CC=/usr/bin/clang
#export CXX=/usr/bin/clang++

# environment variables
export BLOCKSIZE=1k
export CVS_RSH=/usr/bin/ssh
export IRCNAME="*Unknown*"
export LESS="-i"
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

#Matlab
alias matlab='/Applications/MATLAB_R2022a.app/bin/matlab -nodesktop -nosplash $*'

# i'm too lazy to type these out
# alias emacs='emacs -nw'
alias btop='bpytop'
alias calc='perl -pe "print eval(\$_) . chr(10);"'
alias cdu="cvs -q diff -upRN"
alias cp="cp -i"
#alias gs="git status"
alias jobs="jobs -p"
alias k9="kill -9 %1"
alias ll="ls -alF"
alias ls="ls -aF --color"
alias mv="mv -i"
alias offline_mutt="mutt -R -F ~/.muttrc.offline"
alias ph="ps auwwx | head"
alias pg="ps auwwx | grep -i -e ^USER -e "
alias publicip="curl -s http://ifconfig.me "
alias rg="rg --color=never -N -z"

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
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
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
source ~/.config/zsh/plugins/nix-shell/nix-shell.plugin.zsh
source ~/.config/zsh/plugins/fzf.zsh
source ~/.config/zsh/plugins/sudo.zsh


#case insensitive completion
#zstyle ':completion:*' menu select matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

#zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

autoload -Uz compinit && compinit

alias enablemamba='eval $__conda_setup'
export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
. "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh"
__conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"

# ruby enable
eval "$(rbenv init - zsh)"

# opam configuration
[[ ! -r /Users/getz/.opam/opam-init/init.zsh ]] || source /Users/getz/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

#p10k
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
source ~/.config/powerlevel10k/p10k.zsh


#profiling
#zprof
 
 # Nix
 if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
 fi
 # End Nix

export CFLAGS='-Wall -Werror -Wextra'
 
# ccc: cc with filename
function ccc() {
    file=$(basename "$1" .c)
        cc ${CFLAGS} -o "$file" "$1"
        }
        
function cxx() {
    file=$(basename "$1" .cpp)
        c++ -o "$file" "$1"
        }

if [ -n "$INSIDE_EMACS" ]; then
  chpwd() { print -P "\033AnSiTc %d" }
  print -P "\033AnSiTu %n"
  print -P "\033AnSiTc %d"
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




# setup ctrl + arrows
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}

COLOR_DEF=$'%f'
COLOR_GIT=$'%F{39}'
setopt PROMPT_SUBST

#PS1="%m:%~%(!.#.$) "                 # prompt
export PROMPT='%n@%m%D{} [%~] ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}
-> '

#linebreak after each command
#precmd() {
#    precmd() {
#        echo
#    }
#}

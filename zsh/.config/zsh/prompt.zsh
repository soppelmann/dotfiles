#PS1="%m:%~%(!.#.$) "                 # prompt
PS1='%n@%m%D{} [%~]
-> '

#linebreak after each command
precmd() {
    precmd() {
        echo
    }
}

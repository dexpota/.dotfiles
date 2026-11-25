function cless() {
    if (( $+commands[ccat] )); then
        ccat -C always "$1" | less -R
    else
        print -u2 -- "Missing ccat command."
        return 1
    fi
}

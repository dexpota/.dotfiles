function cless() {
    if [ -x "$(command -v ccat)" ]; then
        ccat -C always $1 | less -R
    else
        echo "Missing ccat command." >&2
        return 1
    fi
}

function cless() {
    if [ -x "$(command -v ccat)" ]; then
        ccat -C always $1 | less -R
    else
        echo "Missing ccat command." >&2
        return 1
    fi
}

# Start the system-configuration Codex profile from the home directory.
function codex-toolbelt() {
    CODEX_HOME="$HOME/.codex-toolbelt" command codex --cd "$HOME" "$@"
}

alias ctb='codex-toolbelt'

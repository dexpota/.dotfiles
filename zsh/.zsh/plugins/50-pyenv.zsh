(( $+commands[pyenv] )) || return 0

export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT/shims" ]]; then
    typeset -U path
    path=("$PYENV_ROOT/shims" "${path[@]}")
fi

_load_pyenv() {
    local initialization

    initialization=$(command pyenv init - --no-rehash) || return
    eval "$initialization"
}

# Pyenv replaces this wrapper with its own function after initialization.
pyenv() {
    local -a arguments=("$@")

    _load_pyenv || return
    pyenv "${arguments[@]}"
}

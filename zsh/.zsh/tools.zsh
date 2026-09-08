export NVM_DIR="$HOME/.nvm"

# Load NVM only when it is used directly.
typeset -g _nvm_loaded=0

_load_nvm() {
    (( _nvm_loaded )) && return 0

    if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
        print -u2 -- "nvm: initialization script not found: $NVM_DIR/nvm.sh"
        return 1
    fi

    source "$NVM_DIR/nvm.sh" --no-use || return 1
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
    typeset -g _nvm_loaded=1
}

# This wrapper is replaced by NVM's real function when _load_nvm runs.
nvm() {
    _load_nvm || return
    nvm "$@"
}

export PYENV_ROOT="$HOME/.pyenv"

# Pyenv shims select versions from .python-version without shell initialization.
path=("$PYENV_ROOT/shims" ${path:#"$PYENV_ROOT/shims"})

_load_pyenv() {
    local initialization

    initialization=$(command pyenv init - --no-rehash) || return
    eval "$initialization"
}

# This wrapper is replaced by pyenv's real function after the first invocation.
pyenv() {
    local -a arguments=("$@")

    _load_pyenv || return
    pyenv "${arguments[@]}"
}

# The next line updates PATH for the Google Cloud SDK.
if [[ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]]; then
    source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
fi

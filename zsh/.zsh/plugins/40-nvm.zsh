NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] || return 0
export NVM_DIR

# Load NVM only when it is used directly.
typeset -g _nvm_loaded=0

_load_nvm() {
    (( _nvm_loaded )) && return 0

    source "$NVM_DIR/nvm.sh" --no-use || return 1
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
    typeset -g _nvm_loaded=1
}

# NVM replaces this wrapper with its own function when initialized.
nvm() {
    _load_nvm || return
    nvm "$@"
}

export JAVA_HOME=`/usr/libexec/java_home -v 17`
export ANDROID_HOME=$HOME/Library/Android/sdk
export KUBECONFIG=~/.kube/config
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.scripts
export PATH=$PATH:$HOME/.git-commands
export PATH=$PATH:$HOME/go/bin
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
export PATH="/opt/homebrew/opt/conan@1/bin:$PATH"


function cless() {
    if [ -x "$(command -v ccat)" ]; then
        ccat -C always $1 | less -R
    else
        echo "Missing ccat command." >&2
        return 1
    fi
}

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

# Keep pyenv completion available before the first explicit pyenv command.
source /opt/homebrew/opt/pyenv/completions/pyenv.zsh

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/fabrizio/.docker/completions $fpath)
# End of Docker CLI completions

# Smarter completion initialization
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

export PATH="$HOME/.local/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/fabrizio/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/fabrizio/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/fabrizio/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/fabrizio/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Initialize the prompt after the rest of the interactive shell configuration.
eval "$(starship init zsh)"

# Keep pyenv completion available before the first explicit pyenv command.
source /opt/homebrew/opt/pyenv/completions/pyenv.zsh

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/fabrizio/.docker/completions $fpath)
# End of Docker CLI completions

# Smarter completion initialization.
autoload -Uz compinit
if [[ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]]; then
    compinit
else
    compinit -C
fi

# The next line enables shell command completion for gcloud.
if [[ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
fi

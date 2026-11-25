# Optional integrations add their completion directories before compinit.
[[ -r /opt/homebrew/opt/pyenv/completions/pyenv.zsh ]] && source /opt/homebrew/opt/pyenv/completions/pyenv.zsh
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" "${fpath[@]}")
typeset -U fpath

# Homebrew's Zsh wrapper otherwise searches for this on the first Git
# completion, which noticeably delays branch completion.
if (( $+commands[git] )); then
    git_completion_script="${commands[git]:h:h}/share/zsh/site-functions/git-completion.bash"
    if [[ -r "$git_completion_script" ]]; then
        zstyle ':completion:*:*:git:*' script "$git_completion_script"
    fi
    unset git_completion_script
fi

autoload -Uz compinit
if [[ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]]; then
    compinit
else
    compinit -C
fi

google_cloud_sdk="$HOME/.local/share/google-cloud-sdk"
if [[ -r "$google_cloud_sdk/completion.zsh.inc" ]]; then
    source "$google_cloud_sdk/completion.zsh.inc"
fi
unset google_cloud_sdk

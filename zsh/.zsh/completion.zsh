# Keep pyenv completion available before the first explicit pyenv command.
source /opt/homebrew/opt/pyenv/completions/pyenv.zsh

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/fabrizio/.docker/completions $fpath)
# End of Docker CLI completions

# Avoid repeated completion searches when tools add the same directory.
typeset -U fpath

# Homebrew's Zsh wrapper otherwise searches for this on the first Git
# completion, which noticeably delays branch completion.
_git_completion_script="${commands[git]:h:h}/share/zsh/site-functions/git-completion.bash"
if [[ -r "$_git_completion_script" ]]; then
    zstyle ':completion:*:*:git:*' script "$_git_completion_script"
fi
unset _git_completion_script

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

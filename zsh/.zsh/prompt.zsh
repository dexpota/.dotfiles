# Initialize the prompt after the rest of the interactive shell configuration.
eval "$(starship init zsh)"

# Preserve the timing for the initial prompt, then remove it before the next.
autoload -Uz add-zsh-hook
typeset -gi _starship_prompt_count=0
_clear_starship_startup_time() {
    ((++_starship_prompt_count > 1)) || return

    unset STARSHIP_SHELL_STARTUP_TIME _starship_prompt_count
    add-zsh-hook -d precmd _clear_starship_startup_time
}
add-zsh-hook precmd _clear_starship_startup_time

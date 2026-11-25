(( $+commands[starship] )) || return 0

# Initialize the prompt after the rest of the interactive configuration.
starship_bin="${commands[starship]}"
starship_init="$("$starship_bin" init zsh)"

# Starship embeds its executable path in prompt substitutions without quoting
# it. Use the command name there so home-directory spaces do not split it.
starship_init="${starship_init//${starship_bin}/starship}"
eval "$starship_init"
unset starship_bin starship_init

# Preserve the timing for the initial prompt, then remove it before the next.
autoload -Uz add-zsh-hook
typeset -gi _starship_prompt_count=0
_clear_starship_startup_time() {
    ((++_starship_prompt_count > 1)) || return

    unset STARSHIP_SHELL_STARTUP_TIME _starship_prompt_count
    add-zsh-hook -d precmd _clear_starship_startup_time
}
add-zsh-hook precmd _clear_starship_startup_time

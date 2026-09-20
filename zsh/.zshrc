# Load the interactive configuration in dependency order.
zmodload zsh/datetime
typeset -gF 3 _zsh_startup_started_at="$EPOCHREALTIME"

config_directory="${${(%):-%N}:A:h}/.zsh"
for config_file in "$config_directory"/{environment,functions,tools,completion,prompt}.zsh; do
    [[ -r "$config_file" ]] && source "$config_file"
done
unset config_file config_directory

typeset -gF 3 _zsh_startup_elapsed=$((EPOCHREALTIME - _zsh_startup_started_at))
export STARSHIP_SHELL_STARTUP_TIME="${_zsh_startup_elapsed}s"
unset _zsh_startup_elapsed _zsh_startup_started_at

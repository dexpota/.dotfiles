# Load optional interactive plugins in filename order.
zmodload zsh/datetime
typeset -gF 3 _zsh_startup_started_at="$EPOCHREALTIME"

plugin_directory="${${(%):-%N}:A:h}/.zsh/plugins"
for plugin_file in "$plugin_directory"/*.zsh(N); do
    [[ -r "$plugin_file" ]] && source "$plugin_file"
done
unset plugin_file plugin_directory

typeset -gF 3 _zsh_startup_elapsed=$((EPOCHREALTIME - _zsh_startup_started_at))
export STARSHIP_SHELL_STARTUP_TIME="${_zsh_startup_elapsed}s"
unset _zsh_startup_elapsed _zsh_startup_started_at

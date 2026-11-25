# Login-specific setup is split into optional files under .zsh/login-plugins.
typeset -U path

plugin_directory="${${(%):-%N}:A:h}/.zsh/login-plugins"
for plugin_file in "$plugin_directory"/*.zsh(N); do
    [[ -r "$plugin_file" ]] && source "$plugin_file"
done
unset plugin_file plugin_directory

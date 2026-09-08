# Load the interactive configuration in dependency order.
config_directory="${${(%):-%N}:A:h}/.zsh"
for config_file in "$config_directory"/{environment,functions,tools,completion,prompt}.zsh; do
    [[ -r "$config_file" ]] && source "$config_file"
done
unset config_file config_directory

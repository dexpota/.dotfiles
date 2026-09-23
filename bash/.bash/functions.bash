# Compatibility entry point for existing Bash configurations.
if [ -r "$HOME/.shell/functions.sh" ]; then
    . "$HOME/.shell/functions.sh"
else
    functions_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
    . "$functions_directory/../../shell/.shell/functions.sh"
    unset functions_directory
fi

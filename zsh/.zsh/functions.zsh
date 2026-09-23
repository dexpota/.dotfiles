# Compatibility entry point for existing Zsh configurations.
if [[ -r "$HOME/.shell/functions.sh" ]]; then
    source "$HOME/.shell/functions.sh"
else
    source "${${(%):-%N}:A:h}/../../shell/.shell/functions.sh"
fi

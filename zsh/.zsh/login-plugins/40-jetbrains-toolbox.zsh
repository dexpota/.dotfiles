toolbox_scripts="$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
if [[ -d "$toolbox_scripts" ]]; then
    path+=("$toolbox_scripts")
fi
unset toolbox_scripts

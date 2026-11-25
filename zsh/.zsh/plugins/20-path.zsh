typeset -U path

typeset -a prepend_paths
prepend_paths=()
for directory in \
    "$HOME/.local/bin" \
    /opt/homebrew/opt/conan@1/bin \
    /opt/homebrew/opt/node@18/bin; do
    [[ -d "$directory" ]] && prepend_paths+=("$directory")
done
path=("${prepend_paths[@]}" "${path[@]}")
unset prepend_paths

for directory in "$HOME/.scripts" "$HOME/.git-commands" "$HOME/go/bin" "$ANDROID_HOME/platform-tools"; do
    [[ -d "$directory" ]] && path+=("$directory")
done
unset directory

mise_shims="$HOME/.local/share/mise/shims"
if [[ -d "$mise_shims" ]]; then
    path=("$mise_shims" $path)
fi
unset mise_shims

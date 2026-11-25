google_cloud_sdk="$HOME/.local/share/google-cloud-sdk"
if [[ -r "$google_cloud_sdk/path.zsh.inc" ]]; then
    source "$google_cloud_sdk/path.zsh.inc"
fi
unset google_cloud_sdk

[[ -n "${KITTY_INSTALLATION_DIR:-}" ]] || return 0
(( $+_ksi_state )) && return 0

kitty_integration="$KITTY_INSTALLATION_DIR/shell-integration/zsh/kitty-integration"
[[ -r "$kitty_integration" ]] || return 0

export KITTY_SHELL_INTEGRATION="enabled"
autoload -Uz -- "$kitty_integration"
kitty-integration
unfunction kitty-integration
unset kitty_integration

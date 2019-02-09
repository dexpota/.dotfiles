#!/usr/bin/env bash
#
# @author 		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license
#  This work is licensed under the terms of the MIT license.
#  For a copy, see <https://opensource.org/licenses/MIT>.

usage() {
	cat << EOU
shortcuts

Usage:
	shortcuts <folders> <configs>
EOU
}

if ! command -v docopts >/dev/null 2>&1; then
	echo "docopts is not installed."
	exit -1
fi

# processing arguments
eval "$(docopts -h "$(usage)" : "$@")"

# Shell rc file (i.e. bash vs. zsh, etc.)
shellrc="$HOME/.bashrc"

# Output locations
shell_shortcuts="$HOME/.shortcuts"
ranger_shortcuts="$HOME/.config/ranger/shortcuts.conf"

# Remove
rm -f "$shell_shortcuts" "$ranger_shortcuts" 

# Ensuring that output locations are properly sourced
# (grep "source ~/.shortcuts"  "$shellrc")>/dev/null || echo "source ~/.shortcuts" >> "$shellrc"
# (grep "source ~/.config/ranger/shortcuts.conf" "$HOME/.config/ranger/rc.conf")>/dev/null || echo "source ~/.config/ranger/shortcuts.conf" >> "$HOME/.config/ranger/rc.conf"

# Format the `folders` file in the correct syntax and sent it to all three configs.
sed "/^#/d" "$folders" | tee >(awk '{print "alias "$1"=\"cd "$2" && ls -a\""}' >> "$shell_shortcuts") \
	| awk '{print "map g"$1" cd "$2"\nmap t"$1" tab_new "$2"\nmap m"$1" shell mv -v %s "$2"\nmap Y"$1" shell cp -rv %s "$2}' >> "$ranger_shortcuts"

# Format the `configs` file in the correct syntax and sent it to both configs.
sed "/^#/d" "$configs" | tee >(awk '{print "alias "$1"=\"$EDITOR "$2"\""}' >> "$shell_shortcuts") \
	| awk '{print "map "$1" shell $EDITOR "$2}' >> "$ranger_shortcuts"

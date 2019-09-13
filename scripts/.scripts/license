#!/usr/bin/env bash
#
# @author 		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license
#  This work is licensed under the terms of the MIT license.
#  For a copy, see <https://opensource.org/licenses/MIT>.


usage() {
	cat << EOU
license

Usage:
	license list
	license description <license>
	license <license>
EOU
}


if ! command -v docopts >/dev/null 2>&1; then
	echo "This script require docopts to be installed, please install docopts."
	exit -1
fi

# processing arguments
eval "$(docopts -h "$(usage)" : "$@")"

if $list; then
	curl -s https://api.github.com/licenses | jq -r ".[] | [.key, .name] | @csv"
elif $description; then
	curl -s https://api.github.com/licenses/$license | jq -r ".description"
else
	# TODO with some licenses you have to modify the body, see mit.
	body=$(curl -s https://api.github.com/licenses/$license | jq -r '.body')
	echo "$body"
fi

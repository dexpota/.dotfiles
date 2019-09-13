#!/usr/bin/env bash
#
# @author 		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license
#  This work is licensed under the terms of the MIT license.
#  For a copy, see <https://opensource.org/licenses/MIT>.

# TODO make this script hunts more tags

usage() {
	cat << EOU
tags-hunt

Usage:
	tags-hunt <directory> [options]

Options:
	-t,--todo  Search for TODO tags.
	-b,--bug  Search for BUG tags.
	-f,--fix-me  Search for FIXME tags.
	-h,--hack  Search for HACK tags.
	-u,--undone  Search for UNDONE tags.
	-v,--verbose  Output more informations.
	-d,--debug  Enable debug mode, output even more informations.
EOU
}


verbose() {
	[ $verbose = "true" ]
}

search() {
	local tag="$1"
	local result=$(grep -n "$tag" "$filename")

	if [ ! -z "$result" ]; then
		printf "%s\n" "$filename"
		#printf "\t%.10s\n" "$result"
		echo "$result" |  sed "s/^\(.\{0,${columns}\}\).*$/  \1/"
	fi
}

main() {
	columns=$(tput cols)
	columns=$(expr $columns - 4)

	find $directory \( -type d -name '*.[!.]*' \) -prune \
		-or -type f -not -name '.*' -print0 | while read -d $'\0' filename
	do
		search TODO
	done
}

# check if script is being executed
if [[ $_ == $0 ]]; then
	eval "$(docopts -h "$(usage)" : "$@")"
	main
fi

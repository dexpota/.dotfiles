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
todo-hunt

Usage:
	todo-hunt <directory> [options]

Options:
	-v,--verbose  Output more information
	-d,--debug  Enable debug mode, output even more informations
EOU
}


verbose() {
	[ $verbose = "true" ]
}

main() {
	columns=$(tput cols)
	columns=$(expr $columns - 4)

	find $directory \( -type d -name '*.[!.]*' \) -prune \
		-or -type f -not -name '.*' -print0 | while read -d $'\0' filename
	do
		result=$(grep -n "TODO" "$filename")

		if [ $? -eq 0 ]
		then
			printf "%s\n" "$filename"
			#printf "\t%.10s\n" "$result"
			echo "$result" |  sed "s/^\(.\{0,${columns}\}\).*$/  \1/"
		fi
	done
}

# check if script is being executed
if [[ $_ == $0 ]]; then
	eval "$(docopts -h "$(usage)" : "$@")"
	main
fi

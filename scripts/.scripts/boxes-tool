#!/usr/bin/env bash


function is_integer() {
	if [ "$#" -ne 1 ]; then
		echo "Wrong number of arguments for function is_integer" >&2
		exit -1
	fi

	re="^[0-9]+$"
	if ! [[ "$1" =~ "$re" ]]; then
		echo "$1 is not a valid integer value." >&2
		exit -1
	fi
}

if [ "$#" -ne 3 ]; then
	echo "Wrong number of arguments." >&2
	exit -1
fi

filepath="$1"

start_line_no=$2
end_line_no=$3

is_integer "$start_line_no"
is_integer "$end_line_no"

sed -n "${start_line_no},${end_line_no}p" "$filepath" | boxes
commented_text="$(sed -n "${start_line_no},${end_line_no}p" "$filepath" | boxes)"

gsed -i "${start_line_no},${end_line_no}{r /dev/stdin
d}" "$filepath" <<< "$commented_text"

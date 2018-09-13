#!/usr/bin/env bash

directory=$1

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
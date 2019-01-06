#!/usr/bin/env bash

# if dircolors command exists we let it generate the bash code to initialize
# LS_COLORS variable.
if command -v dircolors 1>/dev/null 2>&1; then
	# if the ".dircolors" directory exists we load the colors from it,
	# otherwise dircolors uses its predefined database
	echo Here
	test -r ~/.dircolors \
		&& eval "$(dircolors -b ~/.dircolors)" \
		|| eval "$(dircolors -b)"
fi

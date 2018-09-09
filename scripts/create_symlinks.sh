#!/usr/bin/env bash

if [ ! -d ~/.dotfiles/scripts ]; then
	echo "Missing dotfiles directory."
	exit
fi

{
	cd ~/.dotfiles/scripts
	find ./ -type f -print0 | while IFS= read -r -d $'\0' line; do
		filename=$(basename "$line")
		
		[[ ! -x "$filename" ]] && chmod +x "$filename"

		(
			cd .scripts \
				&& [ ! -f "${filename%.*}" ] \
				&& ln -s ../$filename ${filename%.*}
		)
	done
}

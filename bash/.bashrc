DOTFILES_DIRECTORY="$HOME"

# Sourcing bash's dotfiles
for dotfile in "$DOTFILES_DIRECTORY"/.{alias,function}
do
	if [ -f "$dotfile" ]
	then
		. $dotfile
	fi
done

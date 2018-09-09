
cd ~/.dotfiles/scripts
find ./ -type f -print0 | while IFS= read -r -d $'\0' line; do
	filename=$(basename "$line")
	
	(cd .scripts && ln -s ../$filename ${filename%.*})
done

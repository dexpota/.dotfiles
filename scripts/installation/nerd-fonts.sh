#!/usr/bin/env bash

{
	cd $(mktemp -d)
	gh-last-release ryanoasis/nerd-fonts .
	
	tarfile=$(ls)
	extraction_directory="./extracted"
	
	tar xf "$tarfile" -C "$extraction_directory"
	
	cd "$extraction_directory" && ./install.sh
}

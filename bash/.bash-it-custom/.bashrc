# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*)	. ~/.bash/functions.sh # source all functions
		return;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x "$(command -v lesspipe)" ] && eval "$(SHELL=/bin/sh lesspipe)"

DOTFILES_DIRECTORY="$HOME"

export EDITOR=vim

# These are cheat's options
# cheat is a simple program used to print cheatsheet on terminal
export CHEATCOLORS=true
export CHEAT_EDITOR=vim

PATH=$PATH:$HOME/.scripts
PATH=$PATH:$HOME/.git-commands

export PATH

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# History's options
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# End history's options

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

DOTFILES_DIRECTORY="$HOME"

# if dircolors command exists we let it generate the bash code to initialize LS_COLORS variable.
if [ -x $(command -v dircolors) ]; then
	# if the ".dircolors" directory exists we load the colors from it, otherwise dircolors uses its predefined database
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" | eval "$(dircolors -b)"
fi

# Sourcing bash's dotfiles
for dotfile in "$DOTFILES_DIRECTORY"/.{prompt,alias,functions}
do
	if [ -f "$dotfile" ]
	then
		. $dotfile
	fi
done

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

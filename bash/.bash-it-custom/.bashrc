# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*)	. ~/.bash/functions.sh # source all functions
		return;;
esac


# Check for color capabilities
# https://unix.stackexchange.com/a/198949
has_color=0
if tput Co > /dev/null 2>&1 ; then
    test "`tput Co`" -gt 2 && has_color=1
elif tput colors > /dev/null 2>&1 ; then
    test "`tput colors`" -gt 2 && has_color=1
fi

# History's options
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
#HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
#shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=1000
#HISTFILESIZE=2000
# End history's options

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x "$(command -v lesspipe)" ] && eval "$(SHELL=/bin/sh lesspipe)"

DOTFILES_DIRECTORY="$HOME"

# if dircolors command exists we let it generate the bash code to initialize LS_COLORS variable.
#if command -v dircolors 1>/dev/null 2>&1; then
#	# if the ".dircolors" directory exists we load the colors from it, otherwise dircolors uses its predefined database
#	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#fi

if [ -f $DOTFILES_DIRECTORY/.bash/colors.sh ]; then
	. $DOTFILES_DIRECTORY/.bash/colors.sh
fi

# Sourcing bash's dotfiles
for dotfile in "$DOTFILES_DIRECTORY"/.bash/{prompt,aliases,functions,directories}.sh
do
	if [ -f "$dotfile" ]
	then
		. $dotfile
	fi
done

# Added as aliases script
#if [[ "$OSTYPE" == "darwin"* ]]; then
#	. "$DOTFILES_DIRECTORY"/.bash/osx-aliases.sh
#fi

# This is already present inside bash-it
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if ! shopt -oq posix; then
#	if [ -f /usr/share/bash-completion/bash_completion ]; then
#		. /usr/share/bash-completion/bash_completion
#	elif [ -f /etc/bash_completion ]; then
#		. /etc/bash_completion
#	fi
#fi

#export ANDROID_SDK=~/Library/Android/sdk
#export ANDROID_SDK_PLATFORM_TOOLS=$ANDROID_SDK/platform-tools

export EDITOR=vim

# These are cheat's options
# cheat is a simple program used to print cheatsheet on terminal
export CHEATCOLORS=true
export CHEAT_EDITOR=vim

# Already present inside go plugin
#export GOPATH=$HOME/.go
#PATH=$PATH:$GOPATH/bin

PATH=$PATH:$HOME/.scripts
PATH=$PATH:$HOME/.git-commands

#PATH=$PATH:$ANDROID_SDK_PLATFORM_TOOLS
export PATH

# virtualenvwrapper setup
#export WORKON_HOME=~/.virtualenvs

#VIRTUALENVWRAPPER_SCRIPT="/usr/local/bin/virtualenvwrapper.sh"
#if [[ -f "$VIRTUALENVWRAPPER_SCRIPT" ]]; then
#
#	if [[ -z "$VIRTUALENVWRAPPER_PYTHON" ]]; then
#		# This slow down the startup of the console
#		if python2 -c "import virtualenvwrapper" 1>/dev/null 2>&1; then
#			VIRTUALENVWRAPPER_PYTHON=$(which python2)
#		elif python3 -c "import virtualenvwrapper" 1>/dev/null 2>&1; then
#			VIRTUALENVWRAPPER_PYTHON=$(which python3)
#		fi
#	fi
#
#	source $VIRTUALENVWRAPPER_SCRIPT
#fi

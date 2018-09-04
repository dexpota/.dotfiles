# vim: set filetype=sh:

if [ -z "$LS_COLORS" ] ; then
	# if LS_COLORS is empty or not set ls will not output colors, use default value	
	export LS_COLORS="no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:"
fi

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then 
	# GNU `ls`
	colorflag="--color"
else
	# macOS `ls`
	colorflag="-G"
fi

# List in short format, human-readable and colorful
alias ls="ls -h ${colorflag}"
# List in long format
alias l="ls -l"
# List in long format and shows almost all files.
alias ll='ls -lA'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# The life is better with some colors
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Let less understand a colorful life
alias less="less -R "

# Add an "alert" alias that notify when a command ends.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Issue: if a long line matches the pattern then it will be printed all and
# will clutter the terminal, a possible fix is to use cut, but then it might
# cut the result
if [ -x "$(command -v parallel)" ]; then
	alias grepall="find . -type f | parallel --no-notice -j+1 grep --color=always -n -H -A 2 -B 2 -I -e"
else
	alias grepall="grep . -R -n -A 2 -B 2 -I -e"
fi

# Git
# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gdiff='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'
# Nice git log
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

# Most used command line tools
alias r="ranger"
alias t="task"
alias g="git"

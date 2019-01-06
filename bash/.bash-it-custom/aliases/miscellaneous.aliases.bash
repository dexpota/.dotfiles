# vim: set filetype=sh:

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

# Humanize df and du
alias df="df -h"
alias du="du -h"
# Summarized version of su
alias dus="du -s"

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

alias zen="command -v curl 1>/dev/null 2>&1 && curl https://api.github.com/zen && echo ''"

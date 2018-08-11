# vim: set filetype=sh:

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# https://misc.flogisoft.com/bash/tip_colors_and_formatting
ESC="\e"
BOLD="\[${ESC}[1m\]"
YELLOW="\[${ESC}[33m\]"
MAGENTA="\[${ESC}[35m\]"
CYAN="\[${ESC}[36m\]"
LGRAY="\[${ESC}[37m\]"
RST="\[${ESC}[0m\]"

TERMINAL_TITLE='\[\e]2;\u@\h\a\]'

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	REMOTE_TAG="(ssh) "
fi

function short_prompt() {
	local result=${PWD##*/}
	echo "${REMOTE_TAG}${BOLD}${YELLOW}\\u${LGRAY}@${CYAN}\h${LGRAY} ${MAGENTA}⋯ ${result} ${LGRAY}>${RST} "
}

function expanded_prompt() {
	echo "${REMOTE_TAG}${BOLD}${YELLOW}\\u${LGRAY}@${CYAN}\h${LGRAY} ${MAGENTA}\w ${LGRAY}>${RST} "
}

function prompt_prompt() {
	local e_prompt="$(expanded_prompt)"
	local expanded=$(PROMPT_COMMAND="" PS1="$e_prompt" "$BASH" --norc -i </dev/null 2>&1 | sed -n '${s/^\(.*\)exit$/\1/p;}')
	local prompt_length=$(echo ${expanded//[$'\001'$'\002']} | sed 's/\x1b\[[0-9;]*m//g' | wc -m)
	local width=$(tput cols)
	local percentage=$(expr $prompt_length \* 100 / $width)
	
	if [ $percentage -gt 50 ]; then
		local prompt="$(short_prompt)"
		PS1="${prompt}"
	else
		PS1="${e_prompt}"
	fi
}


export -f prompt_prompt
export -f short_prompt
export -f expanded_prompt

if [ $has_color = 1 ]; then
	PROMPT="${REMOTE_TAG} ${BOLD}${YELLOW}\u${LGRAY}@${CYAN}\h${LGRAY} ${MAGENTA}\w ${LGRAY}>${RST} "
else
	PROMPT="${debian_chroot:+($debian_chroot)}\u@\h:\w\$"
fi

PS1="${PROMPT}"
PROMPT_COMMAND=prompt_prompt

unset color_prompt
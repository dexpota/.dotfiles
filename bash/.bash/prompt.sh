# vim: set filetype=sh:

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

TERMINAL_TITLE='\[\e]2;\u@\h\a\]'

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	REMOTE_TAG="(ssh) "
fi

function short_prompt() {
	local result=${PWD##*/}
	echo "${REMOTE_TAG}${P_BOLD}${P_YELLOW}\\u${P_LGRAY}@${P_CYAN}\h${P_LGRAY} ${P_MAGENTA}⋯ ${result} ${P_LGRAY}>${P_RST} "
}

function expanded_prompt() {
	echo "${REMOTE_TAG}${P_BOLD}${P_YELLOW}\\u${P_LGRAY}@${P_CYAN}\h${P_LGRAY} ${P_MAGENTA}\w ${P_LGRAY}>${P_RST} "
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

PROMPT_COMMAND=prompt_prompt

unset color_prompt

# for more information visit
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

# escape character
export ESC="\e"
# reset all attributes
export RST="${ESC}[0m"

# formatting
export BOLD="${ESC}[1m"
export DIM="${ESC}[2m"
export UNDERLINED="${ESC}[4m"

# 16 basic colors
export BLACK="${ESC}[30m"
export GRAY="${ESC}[90m"

export RED="${ESC}[31m"
export LRED="${ESC}[91m"

export GREEN="${ESC}[32m"
export LGREEN="${ESC}[92m"

export YELLOW="${ESC}[33m"
export LYELLOW="${ESC}[93m"

export BLUE="${ESC}[34m"
export LBLUE="${ESC}[94m"

export MAGENTA="${ESC}[35m"
export LMAGENTA="${ESC}[95m"

export CYAN="${ESC}[36m"
export LCYAN="${ESC}[96m"

export LGRAY="${ESC}[37m"
export WHITE="${ESC}[97m"

export P_RED="\[${RED}\]"
export P_GREEN="\[${GREEN}\]"
export P_YELLOW="\[${YELLOW}\]"
export P_MAGENTA="\[${MAGENTA}\]"
export P_CYAN="\[${CYAN}\]"
export P_LGRAY="\[${LGRAY}\]"

export P_BOLD="\[${BOLD}\]"
export P_RST="\[${RST}\]"

function format() {
	local text=$1; shift	

	local formatting=""
	for tag in "$@"; do
		formatting="${formatting}${!tag}"
	done

	echo ${formatting}${text}${RST}
}

function red() {
	format "$1" "RED"
}

function blue() {
	format "$1" "BLUE"
}

function bold() {
	format "$1" "BOLD"
}

# vim: set filetype=sh:

# Check the spelling on the command line.
#
# $1 - The words to check for spelling errors.
#
# Examples
#
#	spellcheck wrd
#
function spellcheck() {
	aspell -a < <(echo "$1")
}

# allows to source zshrc twice
export CRONTABCMD=$(which crontab)
function crontab() {
	if [[ $@ == "-e" ]]; then
		vim ~/".crontab" && [ -e ~/".crontab" ] && $CRONTABCMD ~/".crontab"
	else
		$CRONTABCMD $@
	fi
}

export -f crontab

# Copy to clipboard using x11 utility
function clipcopy() {
	xclip -sel c < $1
}
export -f clipcopy

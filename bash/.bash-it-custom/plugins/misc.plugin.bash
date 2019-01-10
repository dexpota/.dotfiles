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

function rgb2hex() {
	printf "#%02x%02x%02x" $(bc <<< $1*255/1) $(bc <<< $2*255/1) $(bc <<< $3*255/1)
}

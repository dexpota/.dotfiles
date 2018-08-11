# vim: set filetype=sh:

# Infect a git repository with a vim plugin, this command is supposed to work with a .dotfiles
# repository
#
# $1 - The git repository's URL.
# $2 - The local directory where to clone the repository as a submodule.
# 
# Examples
# 
#	git-infect-pathogen https://github.com/vim-airline/vim-airline vim-airline
#
function git_infect_pathogen() {
	local target="$(git rev-parse --show-toplevel)/.vim/bundle/"
	[ -f "$target" ] && git submodule add $1 "${target}${2}"
}


# Infect vim with a pathogen
function infect() {
	[ -d "~/.vim/bundle" ] && git clone $1 ~/.vim/bundle
}


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

function android_screen_capture() {
	local filename="$(mktemp -u -p "./").mp4"
	
	echo "Press CTRL+C to stop recording."
	adb shell screenrecord "/sdcard/$filename"
	adb pull "/sdcard/$filename"

	echo "Recording saved as $filename"
}

function to_gif() {
	local directory="$(mktemp -d)"
	local frames_filenames_fmt="$directory/out%06d.png"
	local videofile="$1"

	if [ -x "$(command -v avconv)" ]; then
		avconv -i "$videofile" -vf scale=320:-1:flags=lanczos,fps=8 "frames_filenames_fmt"
	fi

	if [ -x "$(command -v ffmpeg)" ]; then
		ffmpeg -i "$videofile" -vf "scale=480:-1" -r 8 "frames_filenames_fmt"
	fi

	convert -fuzz 5% -delay 12.5 -layers OptimizeTransparency -loop 0 $directory/out%06d.png output.gif
}

function git_find_all() {
	find . -name .git -type d -prune | while read directory ; do
		git -C $directory remote -v
	done
}

# Examples 
# 	get_latest_release adobe-fonts/source-code-pro
#	wget -i <(get_latest_release adobe-fonts/source-code-pro  ".+otf")
#
function get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		jq -r ".assets[] | select(.name | test(\"$2\")) | .browser_download_url"
}

export -f get_latest_release

function gi() { 
	curl -L -s https://www.gitignore.io/api/$@
}

export -f gi

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

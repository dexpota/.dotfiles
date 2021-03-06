# vim: set filetype=sh:

# Infect a git repository with a vim plugin, this command is supposed to work with a .dotfiles
# repository
#
# $1 - The git repository's URL.
# $2 - The local directory where to clone the repository as a submodule.
#
# Examples
#
#   git-infect-pathogen https://github.com/vim-airline/vim-airline vim-airline
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
#   spellcheck wrd
#
function spellcheck() {
    aspell -a < <(echo "$1")
}

function android_screen_record() {
    local filename="$(mktemp -u -p "./").mp4"

    echo "Press CTRL+C to stop recording."
    adb shell screenrecord "/sdcard/$filename"
    adb pull "/sdcard/$filename"

    echo "Recording saved as $filename"
}

function android_screen_capture() {
    local filename="$(mktemp -u -p './').png"

    adb shell screencap -p "/sdcard/$filename"
    adb pull "/sdcard/$filename"

    echo "Capture saved as $filename"
}

function to_gif() {
    local directory="$(mktemp -d)"
    local frames_filenames_fmt="$directory/out%06d.png"
    local videofile="$1"

    if [ -x "$(command -v avconv)" ]; then
        avconv -i "$videofile" -vf scale=320:-1:flags=lanczos,fps=8 "$frames_filenames_fmt"
    elif [ -x "$(command -v ffmpeg)" ]; then
        ffmpeg -i "$videofile" -vf "scale=1280:-1" -r 8 "$frames_filenames_fmt"
    else
        echo "Both of avconv and ffmpeg are missing."
        return
    fi

    convert -fuzz 5% -delay 12.5 -layers OptimizeTransparency -loop 0 $directory/out*.png output.gif
}

function git_find_all() {
    find . -name .git -type d -prune | while read directory ; do
        git -C $directory remote -v
    done
}

# Examples
#   get_latest_release adobe-fonts/source-code-pro
#   wget -i <(get_latest_release adobe-fonts/source-code-pro  ".+otf")
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

function taskscommit() {
    if [ ! -d "$HOME/.task" ]; then
        echo "~/.task is missing"
        return
    fi

    git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task/" commit -am "Updating tasks."
    local retval=$?
    if [ "$retval" -ne 0 ]; then
        echo "git commit failed"
        return
    fi

    git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task/" push
    local retval=$?
    if [ "$retval" -ne 0 ]; then
        echo "git push failed"
        return
    fi
}
export -f taskscommit

function taskspull() {
    if [ ! -d "$HOME/.task" ]; then
        echo "~/.task is missing"
        return
    fi

    git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task/" pull
    local retval=$?
    if [ "$retval" -ne 0 ]; then
        echo "git pull failed"
        return
    fi
}
export -f taskspull

function taskstatus() {
    if [ ! -d "$HOME/.task" ]; then
        echo "~/.task is missing"
        return
    fi

    git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task/" status
}
export -f taskstatus

function resize_and_crop(){
    # $1 input image
    # $3 output image
    # $2 size

    local input="$1"
    local output="$3"
    local size="$2"
    convert "$input" -resize "${size}^" -gravity center -crop "${size}+0+0" +repage "$output"
}

function resize_and_fit(){
    # $1 input image
    # $3 output image
    # $2 size
    # $4 backgroud

    local input="$1"
    local output="$3"
    local size="$2"
    convert "$input" -resize "${size}" -gravity center -extent "${size}" -background "$color" "$output"
}

function rgb2hex() {
    obase=16;
    case "$1" in
        -8)
            printf "#%02x%02x%02x" "$2" "$3" "$4"
            ;;
        -f) # end argument parsing
            red=`bc <<< "$2*255/1"`
            green=`bc <<< "$3*255/1"`
            blue=`bc <<< "$4*255/1"`
            printf "#%02x%02x%02x" "$red" "$green" "$blue"
            ;;
    esac
}

function hex2rgb() {
	#local hex=${1#\#}
	hex=$1
	local red=$((16#${hex:0:2}))
	local green=$((16#${hex:2:2}))
	local blue=$((16#${hex:4:2}))
	echo $red "  " $green "  " $blue
}

function dirdiff() {
    find $1 -type f -print0 | sort -z | xargs -r0 md5sum > list.txt
    find $2 -type f -print0 | sort -z | xargs -r0 md5sum > list.txt
}

function android_debug_key_info() {
    keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
}

export -f android_debug_key_info

function git_submodule_is_updated() {
    git submodule --quiet foreach '''
git fetch --quiet
tracked_branch=$(git rev-parse --abbrev-ref HEAD)
if [ $(git rev-parse origin/$tracked_branch) = $(git rev-parse $tracked_branch) ]; then
    echo $name updated
else
    echo $name is behind
fi
'''
}

export -f git_submodule_is_updated

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if [[ -x $(command -v xclip)  ]]; then
        alias clipcopy='xclip -selection clipboard -in'
        alias clippaste='xclip -selection clipboard -out'
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias clipcopy='pbcopy'
    alias clippaste='pbpaste'
fi

# Copy and paste from and to the clipboard.
# inspired by: https://stackoverflow.com/a/53973493/9942979
function clipboard() {
    if [ -p /dev/stdin ]; then
        clipcopy
    else
        clippaste
    fi
}

urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

JAVA_HOME_PATH="/usr/libexec/java_home"
JAVA_HOME_PATH_VERSION="-v"

function list-java-versions() {
    update-java-alternatives --list | grep java | tr -s '  ' | cut -d '  ' -f3
}

function select-java() {
    export JAVA_HOME=$($JAVA_HOME_PATH $JAVA_HOME_PATH_VERSION $1)
}

function j8() {
    select-java 1.8
}

function j9() {
    select-java 1.9
}

function swagger-list-schemas() {
    jq -r ".components.schemas | keys | .[]"
}

function vstack() {
	montage -tile x1 $@
}

function hstack() {
	montage -tile 1x $@
}

function select-android-device() {
	adb devices -l | sed -n "s/\stransport_id:\s*\(.*\)\s*/\1/p"
}

function android-send-text() {
	local text=$1
	adb shell input text "$text"
}

function android-dump-activities() {
	local package=$1
	adb shell dumpsys activity "$package"
}

function select_directory() {
	while (( "$#" )); do
		if [ -d "$1" ]; then
			echo "$1"
			return
		fi
		shift
	done
}


function load_env {
	filename="$1"

	set -o allexport
	if  [ -f "$filename" ]; then
		source "$filename"
	fi
	set +o allexport
}

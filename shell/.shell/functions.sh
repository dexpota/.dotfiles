# Shared interactive functions for Bash and Zsh.
#
# Keep this file within the common Bash/Zsh language subset. Shell-specific
# startup, prompt, completion, and history configuration stays in its shell's
# own configuration files.

function cless() {
    if ! command -v ccat >/dev/null 2>&1; then
        printf '%s\n' 'cless: ccat is required' >&2
        return 127
    fi

    ccat -C always -- "$@" | less -R
}

function git_infect_pathogen() {
    local target
    target="$(git rev-parse --show-toplevel)/.vim/bundle/"
    [ -d "$target" ] && git submodule add "$1" "${target}${2}"
}

function infect() {
    [ -d "$HOME/.vim/bundle" ] && git clone "$1" "$HOME/.vim/bundle"
}

function spellcheck() {
    printf '%s\n' "$1" | aspell -a
}

function android_screen_record() {
    local filename
    filename="$(mktemp -u -p .).mp4"
    printf '%s\n' 'Press CTRL+C to stop recording.'
    adb shell screenrecord "/sdcard/$filename" && adb pull "/sdcard/$filename"
    printf 'Recording saved as %s\n' "$filename"
}

function android_screen_capture() {
    local filename
    filename="$(mktemp -u -p .).png"
    adb shell screencap -p "/sdcard/$filename" && adb pull "/sdcard/$filename"
    printf 'Capture saved as %s\n' "$filename"
}

function to_gif() {
    local directory frames_filenames_fmt videofile
    directory="$(mktemp -d)"
    frames_filenames_fmt="$directory/out%06d.png"
    videofile="$1"

    if command -v avconv >/dev/null 2>&1; then
        avconv -i "$videofile" -vf scale=320:-1:flags=lanczos,fps=8 "$frames_filenames_fmt"
    elif command -v ffmpeg >/dev/null 2>&1; then
        ffmpeg -i "$videofile" -vf scale=1280:-1 -r 8 "$frames_filenames_fmt"
    else
        printf '%s\n' 'Both avconv and ffmpeg are missing.' >&2
        return 127
    fi

    convert -fuzz 5% -delay 12.5 -layers OptimizeTransparency -loop 0 "$directory"/out*.png output.gif
}

function git_find_all() {
    find . -name .git -type d -prune | while IFS= read -r directory; do
        git -C "$directory" remote -v
    done
}

function get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" |
        jq -r ".assets[] | select(.name | test(\"$2\")) | .browser_download_url"
}

function gi() {
    curl --location --silent "https://www.gitignore.io/api/$*"
}

CRONTABCMD="$(command -v crontab)"
function crontab() {
    if [[ "$#" -eq 1 && $1 == -e ]]; then
        vim "$HOME/.crontab" && [ -e "$HOME/.crontab" ] && "$CRONTABCMD" "$HOME/.crontab"
    else
        "$CRONTABCMD" "$@"
    fi
}

function taskscommit() {
    if [ ! -d "$HOME/.task" ]; then
        printf '%s\n' "$HOME/.task is missing" >&2
        return 1
    fi
    git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task" commit -am 'Updating tasks.' || return
    git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task" push
}

function taskspull() {
    if [ ! -d "$HOME/.task" ]; then
        printf '%s\n' "$HOME/.task is missing" >&2
        return 1
    fi
    git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task" pull
}

function taskstatus() {
    if [ ! -d "$HOME/.task" ]; then
        printf '%s\n' "$HOME/.task is missing" >&2
        return 1
    fi
    git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task" status
}

function resize_and_crop() {
    convert "$1" -resize "${2}^" -gravity center -crop "${2}+0+0" +repage "$3"
}

function resize_and_fit() {
    convert "$1" -resize "$2" -gravity center -extent "$2" -background "$4" "$3"
}

function rgb2hex() {
    local red green blue
    case "$1" in
        -8)
            printf '#%02x%02x%02x' "$2" "$3" "$4"
            ;;
        -f)
            red="$(printf '%s\n' "$2 * 255 / 1" | bc)"
            green="$(printf '%s\n' "$3 * 255 / 1" | bc)"
            blue="$(printf '%s\n' "$4 * 255 / 1" | bc)"
            printf '#%02x%02x%02x' "$red" "$green" "$blue"
            ;;
    esac
}

function hex2rgb() {
    local hex red green blue
    hex=${1#\#}
    red=$((16#${hex:0:2}))
    green=$((16#${hex:2:2}))
    blue=$((16#${hex:4:2}))
    printf '%s  %s  %s\n' "$red" "$green" "$blue"
}

function dirdiff() {
    find "$1" -type f -print0 | sort -z | xargs -0 md5sum > list.txt
    find "$2" -type f -print0 | sort -z | xargs -0 md5sum >> list.txt
}

function android_debug_key_info() {
    keytool -list -v -keystore "$HOME/.android/debug.keystore" -alias androiddebugkey -storepass android -keypass android
}

function git_submodule_is_updated() {
    # shellcheck disable=SC2016
    git submodule --quiet foreach '
git fetch --quiet
tracked_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$(git rev-parse "origin/$tracked_branch")" = "$(git rev-parse "$tracked_branch")" ]; then
    echo "$name updated"
else
    echo "$name is behind"
fi
'
}

case "$OSTYPE" in
    linux-gnu*)
        if command -v xclip >/dev/null 2>&1; then
            alias clipcopy='xclip -selection clipboard -in'
            alias clippaste='xclip -selection clipboard -out'
        fi
        ;;
    darwin*)
        alias clipcopy='pbcopy'
        alias clippaste='pbpaste'
        ;;
esac

function clipboard() {
    if [ -p /dev/stdin ]; then
        clipcopy
    else
        clippaste
    fi
}

urlencode() (
    LC_ALL=C
    export LC_ALL
    local input character
    input=$1
    while [ -n "$input" ]; do
        character=${input%"${input#?}"}
        input=${input#?}
        case "$character" in
            [a-zA-Z0-9.~_-]) printf '%s' "$character" ;;
            *) printf '%%%02X' "'$character" ;;
        esac
    done
)

function urldecode() {
    local escaped
    escaped="$(printf '%s' "$1" | sed 's/+/ /g; s/%/\\\\x/g')"
    printf '%b' "$escaped"
}

JAVA_HOME_PATH=/usr/libexec/java_home
JAVA_HOME_PATH_VERSION=-v

function list-java-versions() {
    update-java-alternatives --list | grep java | tr -s '  ' | cut -d ' ' -f3
}

function select-java() {
    JAVA_HOME="$("$JAVA_HOME_PATH" "$JAVA_HOME_PATH_VERSION" "$1")"
    export JAVA_HOME
}

function j8() { select-java 1.8; }
function j9() { select-java 1.9; }
function swagger-list-schemas() { jq -r '.components.schemas | keys | .[]'; }
function vstack() { montage -tile x1 "$@"; }
function hstack() { montage -tile 1x "$@"; }
function select-android-device() { adb devices -l | sed -n 's/.*transport_id:[[:space:]]*\([^[:space:]]*\).*/\1/p'; }
function android-send-text() { adb shell input text "$1"; }
function android-dump-activities() { adb shell dumpsys activity "$1"; }

function select_directory() {
    while [ "$#" -gt 0 ]; do
        if [ -d "$1" ]; then
            printf '%s\n' "$1"
            return 0
        fi
        shift
    done
    return 1
}

function load_env() {
    local filename=$1
    [ -f "$filename" ] || return 0
    set -o allexport
    # shellcheck disable=SC1090
    . "$filename"
    set +o allexport
}

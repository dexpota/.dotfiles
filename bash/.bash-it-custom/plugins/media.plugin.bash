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

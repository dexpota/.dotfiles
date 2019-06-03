#!/usr/bin/env bash
#
# @author 		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license
#	This work is licensed under the terms of the MIT license.
#	For a copy, see <https://opensource.org/licenses/MIT>.
# @description
#	This script generates scaled versions, of the given image, to be used as
#	Android resources for different screen densities.

# TODO add image type profiles. Let's say you give in input an image file that
# must be used as icon, if you specify its usage the script can decide if the
# resolution is too high for its usage and change it according to some profile.

# Configuration
configure() {
	# exits the script if you try to use uninitialized variables
	set -o nounset
	# exits the script if any statement returns a non-true return value
	# if you are willing to continue when a statement fails you can use this
	# construct: command || true
	set -o errexit
}

usage() {
	cat << EOU
android-resource
	This script generates scaled versions, of the given image, to be used as
	Android resources for different screen densities.

	The user gives in input a png, jpg, gif or 9.png file, and specifiy the
	logical bucket it belongs to. This script will then generates scaled
	versions of this image for missing buckets or the buckets specified in input
	--generate-dpi

Usage:
	android-generate-resources <drawable> (--ldpi | --mdpi | --hdpi | --xhdpi | --xxhdpi | --xxxhdpi) [--generate-dpi=<dpis>] [options]

Options:
	-v,--verbose  Output more information
	-d,--debug  Enable debug mode, output even more informations
EOU
}

verbose() {
	[ "${verbose:-}" = "true" ]
}

logverbose() {
	if verbose; then
		echo "${@}"
	fi
}

debug() {
	[ "${debug:-}" = "true" ]
}

# This function will be called when the script exits or when one of TERM or
# INT signal is received.
cleanup() {
	# your cleaning code here ...
	exit -1
}

initialize() {
	# trap bad exits with the cleanup function
	trap cleanup EXIT INT TERM

	# run bash in debugging mode
	if debug; then
		set -x
	fi
}

main() {
	configure
	initialize

	if [ ! -f "${drawable:-}" ]; then
		echo "$drawable is not a valid file."
		exit -1
	fi

	if verbose; then
		echo "Verbose mode..."
		echo
	elif debug; then
		echo "Debug mode..."
		echo
	fi

	local filename
	filename=$(basename "$drawable")

	declare -a dpi_factors
	dpi_factors[0]=0.75
	dpi_factors[1]=1.00
	dpi_factors[2]=1.50
	dpi_factors[3]=2.00
	dpi_factors[4]=3.00
	dpi_factors[5]=4.00

	declare -a dpi_labels
	dpi_labels[0]="ldpi"
	dpi_labels[1]="mdpi"
	dpi_labels[2]="hdpi"
	dpi_labels[3]="xhdpi"
	dpi_labels[4]="xxhdpi"
	dpi_labels[5]="xxxhdpi"

	local input_dpi
	if "${ldpi:-false}"; then 
		input_dpi=0
	elif "${mdpi:-false}"; then
		input_dpi=1
	elif "${hdpi:-false}"; then
		input_dpi=2
	elif "${xhdpi:-false}"; then
		input_dpi=3
	elif "${xxhdpi:-false}"; then
		input_dpi=4
	elif "${xxxhdpi:-false}"; then
		input_dpi=5
	fi

	logverbose "Generating resources for image file @ ${dpi_labels[$input_dpi]}"

	local input_dpi_factor=${dpi_factors[$input_dpi]}
	local dpis=(0 1 2 3 4 5)

	for dpi in "${dpis[@]}"
	do
		local target_directory="drawable-${dpi_labels[$dpi]}"
		[ ! -d "$target_directory" ] && mkdir "$target_directory"

		local dpi_factor=${dpi_factors[$dpi]}

		local scaling_factor
		echo $dpi_factor
		echo $input_dpi
		scaling_factor=$(bc -l <<< $dpi_factor/$input_dpi_factor*100)

		logverbose "Scaling image using a factor of $scaling_factor%"
		logverbose "Saving file into $target_directory/$filename"

		convert "$drawable" -scale "$scaling_factor%" "$target_directory/$filename"
	done
}

eval "$(docopts -h "$(usage)" : "$@")"
main

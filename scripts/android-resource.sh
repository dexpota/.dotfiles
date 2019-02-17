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
	import_utilites=false
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
	[ $verbose = "true" ]
}

logverbose() {
	if verbose; then
		echo "${@}"
	fi
}

debug() {
	[ $debug = "true" ]
}

import_utilities() {
	# if we want to import common utilities
	if [ "$import_utilites" == true ]; then

		# if an env variable is not defined try a default location
		if [ -z $SCRIPTING_UTILITIES ]; then
			scripting_utilities=$HOME/.script/libs/utilities.sh
		fi

		# Source Scripting Utilities
		if [ -f "$scripting_utilites" ]; then
			source "$scripting_utilities"
		else
			echo "Scripting utilities not found!"
			echo "$scripting_utilities doesn't seem to exists."
			exit -1
		fi
	fi
}

# This function will be called when the script exits or when one of TERM or
# INT signal is received.
cleanup() {
	# your cleaning code here ...
	exit -1
}

initialize() {
	import_utilities

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

	if [ ! -f "$drawable" ]; then
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

	local filename=`basename "$drawable"`

	declare -A dpi_factors
	dpi_factors[ldpi]=0.75
	dpi_factors[mdpi]=1.00
	dpi_factors[hdpi]=1.50
	dpi_factors[xhdpi]=2.00
	dpi_factors[xxhdpi]=3.00
	dpi_factors[xxxhdpi]=4.00

	local input_dpi
	if $ldpi; then
		input_dpi=ldpi
	elif $mdpi; then
		input_dpi=mdpi
	elif $hdpi; then
		input_dpi=hdpi
	elif $xhdpi; then
		input_dpi=xhdpi
	elif $xxhdpi; then
		input_dpi=xxhdpi
	elif $xxxhdpi; then
		input_dpi=xxxhdpi
	fi

	logverbose "Generating resources for image file @ $input_dpi"

	local input_dpi_factor=${dpi_factors[$input_dpi]}
	local dpis=(ldpi mdpi hdpi xhdpi xxhdpi xxxhdpi)

	for dpi in "${dpis[@]}"
	do
		local target_directory="drawable-$dpi"
		[ ! -d $target_directory ] && mkdir "drawable-$dpi"

		local dpi_factor=${dpi_factors[$dpi]}

		local scaling_factor=`bc -l <<< $dpi_factor/$input_dpi_factor*100`

		logverbose "Scaling image using a factor of $scaling_factor%"
		logverbose "Saving file into $target_directory/$filename"

		convert "$drawable" -scale "$scaling_factor%" "$target_directory/$filename"
	done
}

# check if script is being executed
if [ "$0" =  "$BASH_SOURCE" ]; then
	eval "$(docopts -h "$(usage)" : "$@")"
	main
fi

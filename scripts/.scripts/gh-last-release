#!/usr/bin/env bash
#
# @author 		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license
#  This work is licensed under the terms of the MIT license.
#  For a copy, see <https://opensource.org/licenses/MIT>.

usage() {
	cat << EOU
gh-last-release downloads the source code of the latests release for a given
github repository by using GitHub's API v3.

Usage:
	gh-last-release <github_repository> [<target_directory>] [options] [-z|-t]

Options:
	-z,--zip  Download the zip compressed release
	-t,--tar  Download the tar compressed release
	-v,--verbose  Output more information
	-d,--debug  Enable debug mode, output even more informations
EOU
}


verbose() {
	[ $verbose = "true" ]
}

main() {
	if verbose; then
		echo "Verbose mode..."
		echo

		silent=""
	else
		silent="-s"
	fi

	# Removing longest match of slashes from the front
	github_repository=${github_repository##+(/)}
	# Removing longest match of slashes from the back
	github_repository=${github_repository%%+(/)}

	github_api_endpoint="https://api.github.com/repos/$github_repository/releases/latest"

	if verbose; then
		echo "Retrieving last release information from"
		echo "$github_api_endpoint"
		echo
	fi

	response=$(curl -w '\n%{http_code}' $silent -o - $github_api_endpoint)

	if verbose; then
		echo "Response from the server"
		echo "$response"
		echo
	fi

	response_body=$(echo "$response" | head -n -1)
	response_code=$(echo "$response" | tail -1)

	if [[ $response_code == 200 ]]; then
		# extracting tag_name from response
		tag=`jq -r ".tag_name" <<< $response_body`

		if [ $tar == true ]; then
			# extracting tarball url
			release_url=$(echo "$response_body" | jq -r ".tarball_url")
			extension="tgz"
		elif [ $zip == true ]; then
			# extracting zipball url
			release_url=$(echo "$response_body" | jq -r ".zipball_url")
			extension="zip"
		else
			# extracting tarball url
			release_url=$(echo "$response_body" | jq -r ".tarball_url")
			extension="tgz"
		fi

		# computing the output filename
		# Alternative: to retrieve the filename it is possible to search for
		# Content-Disposition header inside the server response, run this command:
		# curl --head -L $tarball_url
		filename=${github_repository/\//.}.$tag.$extension

		if [ -z $target_directory ]; then
			target_directory=$PWD
		fi

		if verbose; then
			echo "Downloading tarball release from"
			echo "$tarball_url into $target_directory"
		fi

		# downloading the archive
		curl $silent -L $release_url > "$target_directory/$filename"
	fi
}

# check if script is being executed
if [[ $_ == $0 ]]; then
	eval "$(docopts -h "$(usage)" : "$@")"
	main
fi

#!/usr/bin/env bash

usage() {
	cat << EOU
gh-last-release

Usage:
	gh-last-release <github_path> <target_directory> [options]

Options:
	-v,--verbose  Output more information
	-d,--debug  Enable debug mode, output even more informations
EOU
}

eval "$(docopts -h "$(usage)" : "$@")"

verbose() {
	[ $verbose = "true" ]
}

if verbose; then
	echo "Verbose mode..."
	echo

	silent=""
else
	silent="-s"
fi

# Removing longest match of slashes from the front
github_path=${github_path##+(/)}
# Removing longest match of slashes from the back
github_path=${github_path%%+(/)}

github_api_endpoint="https://api.github.com/repos/$github_path/releases/latest"

if verbose; then
	echo "Retrieving last release information from"
	echo "$github_api_endpoint"
	echo
fi

response=$(curl -w '\n%{http_code}' $silent -o - $github_api_endpoint)

response_body=$(echo "$response" | head -n -1)
response_code=$(echo "$response" | tail -1)

# TODO target_directory should be optional and if not set should be the current
# one
# target_directory="."

if [[ $response_code == 200 ]]; then
	# extracting tag_name from response
	tag=`jq -r ".tag_name" <<< $response_body`

	# extracting tarball url
	tarball_url=$(echo "$response_body" | jq -r ".tarball_url")

	# computing the output filename
	# Alternative: to retrieve the filename it is possible to search for
	# Content-Disposition header inside the server response, run this command:
	# curl --head -L $tarball_url
	filename=${github_path/\//.}.$tag.tgz

	if verbose; then
		echo "Downloading tarball release from"
		echo "$tarball_url into $target_directory"
	fi

	# downloading the archive
	curl $silent -L $tarball_url > "$target_directory/$filename"
fi

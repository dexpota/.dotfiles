#!/usr/bin/env bash

usage() {
	cat << EOU
gh-last-release

Usage:
	gh-last-release <github_path> <target_directory>
EOU
}

eval "$(docopts -h "$(usage)" : "$@")"

github_api_endpoint="https://api.github.com/repos/$github_path/releases/latest"

response=$(curl -w '\n%{http_code}' -s -o - $github_api_endpoint) 

response_body=$(echo "$response" | head -n -1)
response_code=$(echo "$response" | tail -1)

# TODO target_directory should be optional and if not set should be the current
# one
# target_directory="."

if [[ $response_code == 200 ]]; then
	# echo $response_body | jq "keys"
	name=$(echo $response_body | jq -r ".name")
	tarball_url=$(echo "$response_body" | jq -r ".tarball_url")
	
	repository_name=$(basename $1)
	target_filename="${repository_name}_${name}.tar"
	(cd $target_directory; curl -L $tarball_url > "$target_filename")
fi

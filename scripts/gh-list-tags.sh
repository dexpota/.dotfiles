#!/usr/bin/env bash
#
# @author 		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license
#  This work is licensed under the terms of the MIT license.
#  For a copy, see <https://opensource.org/licenses/MIT>.

usage() {
	cat << EOU
gh-list-tags list the tags associated with the given github repository by using
GitHub's API v3.

Usage:
	gh-last-release <github_repository> [options]

Options:
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

	github_api_endpoint="https://api.github.com/repos/$github_repository/tags"

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
		jq -r ".[].name" <<< "$response_body"
	fi
}

# check if script is being executed
if [[ $_ == $0 ]]; then
	eval "$(docopts -h "$(usage)" : "$@")"
	main
fi

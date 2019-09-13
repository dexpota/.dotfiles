#!/usr/bin/env bash
#
# @author		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license
#  This work is licensed under the terms of the MIT license.
#  For a copy, see <https://opensource.org/licenses/MIT>.

usage() {
	cat << EOU
gh-last-release-assets downloads all assets belonging to the last release of a
given github repository.

Usage:
	gh-last-release-assets <github_repository> <target_directory>
EOU
}

main() {
	github_api_endpoint="https://api.github.com/repos/$github_repository/releases/latest"

	response=$(curl -w '\n%{http_code}' -s -o - $github_api_endpoint)

	response_body=$(echo "$response" | head -n -1)
	response_code=$(echo "$response" | tail -1)

	# TODO target_directory should be optional and if not set should be the current
	# one
	# target_directory="."

	if [[ $response_code == 200 ]]; then
		{
			cd "$target_directory"
			echo $response_body \
				| jq -r ".assets[] | \"\(.browser_download_url) \(.name) \"" \
				| parallel --colsep " " --no-notice -j+1 curl -L {1} -o {2}
		}
	fi
}

# check if script is being executed
if [[ $_ == $0 ]]; then
	eval "$(docopts -h "$(usage)" : "$@")"
	main
fi

#!/usr/bin/env bash
#
# @author 		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license
#  This work is licensed under the terms of the MIT license.
#  For a copy, see <https://opensource.org/licenses/MIT>.

usage() {
	cat << EOU
gh-curl-repo

Usage:
	gh-curl-repo <github_path> <regex> <target_directory>
EOU
}

eval "$(docopts -h "$(usage)" : "$@")"

github_api_endpoint="https://api.github.com/repos/$github_path/contents/"

response=$(curl -w '\n%{http_code}' -s -o - $github_api_endpoint) 

response_body=$(echo "$response" | head -n -1)
response_code=$(echo "$response" | tail -1)

# TODO target_directory should be optional and if not set should be the current
# one
# target_directory="."

if [[ $response_code == 200 ]]; then
	echo "$response_body" | \
		jq -r ".[] | \"\(.path) \(.download_url)\"" | \
		sed -n "/$regex/p" \
		| parallel --colsep " " --no-notice -j+1 curl -L {2} -o {1}	
fi

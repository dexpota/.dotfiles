#!/usr/bin/env bash
#
# @author       Fabrizio Destro
# @copyright    Copyright 2018, Fabrizio Destro
# @license
#  This work is licensed under the terms of the MIT license.
#  For a copy, see <https://opensource.org/licenses/MIT>.

usage() {
    cat << EOU
gh-last-release-asset download the specified asset belonging to the last
release of a given github repository.

Usage:
    gh-last-release-assets <github_repository> <asset> [<target_directory>]
EOU
}

main() {
    github_api_endpoint="https://api.github.com/repos/$github_repository/releases/latest"

	if [ -z $target_directory ]; then
		target_directory=$PWD
	fi

	curl -s "$github_api_endpoint" \
        | jq -r ".assets[].browser_download_url" \
        | grep "$asset" \
        | wget -i - --directory-prefix=$target_directory

}

# check if script is being executed
if [[ $_ == $0 ]]; then
    eval "$(docopts -h "$(usage)" : "$@")"
    main
fi

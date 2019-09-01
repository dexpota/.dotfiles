#!/usr/bin/env bash

# @author		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license		see repository's license
# @references
# https://github.com/bertrandmartel/gitlab-backup

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
gl-repo-backup
	This script clone your repositories from gitlab and makes a backup archive.

Usage:
	gl-repo-backup <backup_target_directory> <archive_prefix>

Options:
	-v,--verbose  Output more information
	-d,--debug  Enable debug mode, output even more informations
EOU
}

configure
eval "$(docopts -h "$(usage)" : "$@")"

# read script arguments
backup_directory=${backup_target_directory:-}
filename=${archive_prefix:-}

config_file=~/.gitlab
tar_filename=$filename-$(date +%F).tgz

# env variable > rc file
if [ -f "$config_file" ]; then
	# read global configuration file
	# shellcheck source=/dev/null
	. "$config_file"
fi

if [ -n "${GITLAB_TOKEN:-}" ]; then
	# if defined use env variable
	token="$GITLAB_TOKEN"
fi

if [ -n "${GITLAB_API:-}" ]; then
	# if defined use env variable
	api="$GITLAB_API"
fi

if [ -z "$token" ]; then
	# if no token is defined then exit
	echo "Gitlab's token is not defined. Create a configuration file or define GITLAB_TOKEN env variable."
	exit 1
fi

if [ -z "$api" ]; then
	# if no api is defined then exit
	echo "Gitlab API's url is not defined. Create a configuration file or define GITLAB_API env variable."
	exit 1
fi

endpoint="api/v3/projects/visible?per_page=100&owned=true"

tmp_directory=$(mktemp -d)

[ -d "$backup_directory" ] ||
	{ printf "Backup directory doesn't exits.\n%s\n" "$backup_directory" \
		&& exit 1; }

backup_directory=$(realpath "$backup_directory")

(
	cd "$tmp_directory" || exit 1

	# for each repository do a git clone
	curl --header "PRIVATE-TOKEN: $token" "$api/$endpoint" |
		jq -r ".[].ssh_url_to_repo" |
		xargs -i git clone --mirror {}

	# for each cloned repo create a bundle
	find . -mindepth 1 -maxdepth 1 -type d -exec git --git-dir {} bundle create {}.bundle --all \;

	# delete all directories
	find . -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;

	# create an archive
	tar -cvzf "$backup_directory/$tar_filename" -- *

)

rm "$tmp_directory"

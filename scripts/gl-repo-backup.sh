#!/usr/bin/env bash

# read script arguments
backup_directory=$1
filename=$2

config_file=~/.gitlab
tar_filename=$filename-$(date +%F).tgz

# env variable > rc file
if [ -f "$config_file" ]; then
	# read global configuration file
	# shellcheck source=/dev/null
	. "$config_file"
fi

if [ -n "$GITLAB_TOKEN" ]; then
	# if defined use env variable
	token="$GITLAB_TOKEN"
fi

if [ -n "$GITLAB_API" ]; then
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


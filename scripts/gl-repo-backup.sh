#!/usr/bin/env bash


# env variable > rc file

config_file=~/.gitlab
backup_directory=~/.backup

if [ -f "$config_file" ]; then
	. "$config_file"
fi

if [ ! -z "$GITLAB_TOKEN" ]; then
	token="$GITLAB_TOKEN"
fi

if [ ! -z "$GITLAB_API" ]; then
	api="$GITLAB_API"
fi

if [ -z "$token" ]; then
	echo "token is not defined."
	exit -1
fi

if [ -z "$api" ]; then
	echo "api endpoint is not defined."
	exit -1
fi

endpoint="api/v3/projects/visible?per_page=100"

(

cd "$backup_directory" || exit -1

curl --header "PRIVATE-TOKEN: $token" "$api/$endpoint" |
	jq -r ".[].ssh_url_to_repo" |
	xargs -i git clone --mirror {}

find . -mindepth 1 -maxdepth 1 -type d -exec git --git-dir {} bundle create {}.bundle --all \;

find . -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;
)

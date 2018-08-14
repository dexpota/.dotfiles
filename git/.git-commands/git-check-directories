#!/usr/bin/env bash

usage() {
	cat <<EOU
git check-directories

Usage: 
	check-directories <directory> [--all]

Options:
	-a --all  Check all directories.

Arguments:
	directory is the root where to start searching for git repositories.
EOU
}


if ! command -v docopts >/dev/null 2>&1; then
	echo "docopts is not installed."
	exit -1
fi

# processing arguments
eval "$(docopts -h "$(usage)" : "$@")"

if $all; then
	GLOBIGNORE=".:.."
fi

if [[ -d "$directory" ]]; then
	cd "$directory"
	for d in */; do
		cd "$d"
		if [ ! -d ".git" ]; then
			cd ..
			continue
		fi

		git diff --quiet --exit-code
		unstaged_changes=$?
		if [[ $unstaged_changes -eq 1 ]]; then
			printf "[${YELLOW}%s${RST}]" "Local unstaged changes"
		fi

		git diff --cached --quiet --exit-code
		staged_not_committed=$?
		if [[ $staged_not_committed -eq 1 ]]; then
			printf "[${YELLOW}%s${RST}]" "Local changes not committed"
		fi

		if [[ $staged_not_commited -ne 1 && $unstaged_changes -ne 1 ]]; then
			printf "[${GREEN}%s${RST}]" "Everything up-to-date"
		fi
		printf " %s\n" $(pwd)
		cd ..
	done
else
	echo "$directory is not a directory"
fi

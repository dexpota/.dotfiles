#!/usr/bin/env bash

usage() {
	cat <<EOU
git-purge-ignored 

Remove all files which has been indexed by error and should be ignored
accordingly to the .gitignore. 

Usage:
	purge-ignored

Examples
  git_remove_tracked_ignored
EOU
}

if ! command -v docopts >/dev/null 2>&1; then
	echo "docopts is not installed."
	exit -1
fi

# processing arguments
eval "$(docopts -h "$(usage)" : "$@")"

if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1 ; then 
	files=$(git check-ignore --no-index $(git ls-files))
	if [ $? -eq 0 ]; then
		git rm $files >/dev/null
		git status -s | awk '{print $2}' | sort
	fi
else
	echo "Current directory is not a git repository."
	exit 1
fi

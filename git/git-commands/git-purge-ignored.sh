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
	# TODO test this function
	git rm $(git check-ignore --no-index $(git ls-files))	
else
	echo "Current directory is not a git repository."
	return 1
fi

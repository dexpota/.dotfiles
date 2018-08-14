#!/usr/bin/env bash

usage() {
	cat << EOU
git sparse-checkout

Usage:
	sparse-checkout <repository> <dirs>...

Arguments
	repository is the git repository uri
	dirs are all repository's directorires to checkout
EOU
}

if ! command -v docopts >/dev/null 2>&1; then
	echo "docopts is not installed"
	exit -1
fi

# processing arguments
eval "$(docopts -h "$(usage)" : "$@")"

working_directory="$(pwd)"
temp_directory=$(mktemp -d)
repository_name=$(basename -s .git "$repository")
target_directory="${working_directory}/${repository_name}"

cd "$temp_directory"

git init --quiet
git remote add origin $repository
git config core.sparseCheckout true

printf "%s\n" "${dirs[@]}" > .git/info/sparse-checkout
git pull --depth 1 origin master

mkdir "${target_directory}"
mv * "${target_directory}"

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

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
	usage
	exit 0
fi

if [ "$#" -lt 2 ]; then
	usage >&2
	exit 2
fi

repository=$1
shift
dirs=("$@")

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

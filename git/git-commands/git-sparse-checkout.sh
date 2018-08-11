#!/usr/bin/env bash

if [ $# -ne 2 ]; then
	echo "Illegal number of arguments, please specify a repository and a directory."
	exit -1
fi

working_directory="$(pwd)"
temp_directory=$(mktemp -d)

# Reading arguments
git_repository=$1
shift

cd "$temp_directory"

git init
git remote add origin $git_repository
git config core.sparseCheckout true

printf "%s\n" $@ > .git/info/sparse-checkout

git pull origin master

mv * "$working_directory"

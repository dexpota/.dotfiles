#!/usr/bin/env bash

# @author 		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license 		see repository's license
# @see 			https://gist.github.com/chrisroos/1205934

if [ "$#" -ne 2  ]; then
    echo "Illegal number of parameters"
fi

user_id=$1
target_directory=$2

# to import back these keys use this command:
# gpg --import chrisroos-secret-gpg.key
# gpg --import-ownertrust chrisroos-ownertrust-gpg.txt
gpg -a --export "$user_id" > "$target_directory"/"$user_id"-public-gpg.key
gpg -a --export-secret-keys "$user_id" > "$target_directory"/"$user_id"-secret-gpg.key
gpg --export-ownertrust > "$target_directory"/"$user_id"-ownertrust-gpg.txt

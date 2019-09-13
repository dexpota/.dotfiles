#!/usr/bin/env bash

backup_directory=$(realpath ".")

tar_filename=wallabag-$(date +%F).tgz

tmp_directory=$(mktemp -d)

# user@server
server=$1

[ -d "$backup_directory" ] ||
        { printf "Backup directory doesn't exits.\n%s\n" "$backup_directory" \
                && exit 1; }

(
        cd "$tmp_directory" || exit 1

        scp -r "$server:~/wallabag/data/db" .
        scp "$server:~/wallabag/app/config/parameters.yml" .

        # create an archive
        tar -cvzf "$backup_directory/$tar_filename" -- *
)

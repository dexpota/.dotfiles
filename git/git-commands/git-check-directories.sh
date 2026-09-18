#!/usr/bin/env sh

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


all=false
directory=""

for argument in "$@"; do
	case "$argument" in
		-a|--all)
			all=true
			;;
		-h|--help)
			usage
			exit 0
			;;
		-*)
			echo "Unknown option: $argument" >&2
			usage >&2
			exit 2
			;;
		*)
			if [ -n "$directory" ]; then
				usage >&2
				exit 2
			fi
			directory=$argument
			;;
	esac
done

if [ -z "$directory" ]; then
	usage >&2
	exit 2
fi

if [ -d "$directory" ]; then
	cd "$directory"
	for d in */; do
		cd "$d"
		if [ ! -d ".git" ]; then
			cd ..
			continue
		fi

		git diff --quiet --exit-code
		unstaged_changes=$?
		if [ "$unstaged_changes" -eq 1 ]; then
			printf "[${YELLOW}%s${RST}]" "Local unstaged changes"
		fi

		git diff --cached --quiet --exit-code
		staged_not_committed=$?
		if [ "$staged_not_committed" -eq 1 ]; then
			printf "[${YELLOW}%s${RST}]" "Local changes not committed"
		fi

		git diff origin/master..HEAD --quiet --exit-code
		commit_not_pushed=$?
		if [ "$commit_not_pushed" -ne 0 ]; then
			printf "[${YELLOW}%s${RST}]" "Local commit not pushed."
		fi

		if [ "$staged_not_committed" -ne 1 ] && [ "$unstaged_changes" -ne 1 ]; then
			printf "[${GREEN}%s${RST}]" "Everything up-to-date"
		fi
		printf " %s\n" "$(pwd)"
		cd ..
	done
else
	echo "$directory is not a directory"
fi

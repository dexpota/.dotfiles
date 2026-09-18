#!/usr/bin/env sh

set -o errexit
set -o nounset

usage() {
	cat <<'EOF'
Usage: git branch-prune [--force] [--dry-run]

Delete local branches whose configured upstream no longer exists.
By default, branches with unmerged commits are preserved. Use --force
to delete them, or --dry-run to list branches without deleting them.
EOF
}

delete_option=-d
dry_run=false

while [ "$#" -gt 0 ]; do
	case "$1" in
		-f|--force)
			delete_option=-D
			;;
		-n|--dry-run)
			dry_run=true
			;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			echo "Unknown option: $1" >&2
			usage >&2
			exit 2
			;;
	esac
	shift
done

git rev-parse --git-dir >/dev/null 2>&1 || {
	echo "Current directory is not a Git repository." >&2
	exit 1
}

format='%(if:equals=gone)%(upstream:track,nobracket)%(then)%(refname:short)%(end)'
branches=$(LC_ALL=C git branch --format="$format" | sed '/^$/d')

if [ -z "$branches" ]; then
	exit 0
fi

if [ "$dry_run" = true ]; then
	printf '%s\n' "$branches"
	exit 0
fi

printf '%s\n' "$branches" | xargs git branch "$delete_option" --

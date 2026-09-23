#!/usr/bin/env sh

set -o errexit
set -o nounset

usage() {
	cat <<'EOF'
Usage: git branch-align [--force] [branch]

Fetch branch from origin and align the local branch with origin/branch.
Without --force, only a fast-forward update is allowed. With --force,
divergent local commits are discarded, but tracked changes must be clean.
EOF
}

force=false
branch=""

while [ "$#" -gt 0 ]; do
	case "$1" in
		-f|--force)
			force=true
			;;
		-h|--help)
			usage
			exit 0
			;;
		-*)
			echo "Unknown option: $1" >&2
			usage >&2
			exit 2
			;;
		*)
			if [ -n "$branch" ]; then
				echo "Only one branch may be specified." >&2
				exit 2
			fi
			branch="$1"
			;;
	esac
	shift
done

git rev-parse --git-dir >/dev/null 2>&1 || {
	echo "Current directory is not a Git repository." >&2
	exit 1
}

current_branch=$(git symbolic-ref --quiet --short HEAD || true)
if [ -z "$branch" ]; then
	if [ -z "$current_branch" ]; then
		echo "A branch is required when HEAD is detached." >&2
		exit 1
	fi
	branch="$current_branch"
fi

git check-ref-format --branch "$branch" >/dev/null
remote_ref="refs/remotes/origin/$branch"
git fetch --no-tags origin "refs/heads/$branch:$remote_ref"

if [ "$force" = false ]; then
	if [ "$branch" = "$current_branch" ]; then
		git merge --ff-only "$remote_ref"
	elif git show-ref --verify --quiet "refs/heads/$branch"; then
		if ! git merge-base --is-ancestor "$branch" "$remote_ref"; then
			echo "Branch '$branch' has diverged from origin/$branch; rerun with --force to discard local commits." >&2
			exit 1
		fi
		git branch --force "$branch" "$remote_ref"
	else
		git branch "$branch" "$remote_ref"
	fi
	printf "Aligned %s with origin/%s.\n" "$branch" "$branch"
	else
	if ! git diff --quiet || ! git diff --cached --quiet; then
		echo "Refusing forced alignment: tracked files contain uncommitted changes." >&2
		exit 1
	fi

	if [ "$branch" = "$current_branch" ]; then
		git reset --hard "$remote_ref"
	else
		git branch --force "$branch" "$remote_ref"
	fi
	printf "Force-aligned %s with origin/%s.\n" "$branch" "$branch"
fi

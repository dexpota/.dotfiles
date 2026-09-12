#!/usr/bin/env bats

setup() {
	repository_root="$BATS_TEST_DIRNAME/../../.."
	commands=(
		"$repository_root/git/git-commands/git-check-directories.sh"
		"$repository_root/git/git-commands/git-purge-ignored.sh"
		"$repository_root/git/git-commands/git-sparse-checkout.sh"
		"$repository_root/scripts/.scripts/android-resource"
		"$repository_root/scripts/.scripts/gh-curl-repo"
		"$repository_root/scripts/.scripts/gh-last-release"
		"$repository_root/scripts/.scripts/gh-last-release-asset"
		"$repository_root/scripts/.scripts/gh-last-release-assets"
		"$repository_root/scripts/.scripts/gh-list-tags"
		"$repository_root/scripts/.scripts/gl-repo-backup"
		"$repository_root/scripts/.scripts/license"
		"$repository_root/scripts/.scripts/shortcuts"
		"$repository_root/scripts/.scripts/todo-hunt"
	)
}

@test "migrated commands provide help without docopts" {
	for command in "${commands[@]}"; do
		run "$command" --help
		if [ "$status" -ne 0 ]; then
			echo "$command failed with status $status: $output" >&2
			return 1
		fi
		[[ "$output" == *"Usage:"* ]]
	done
}

@test "commands with required arguments reject empty input" {
	for command in "${commands[@]}"; do
		if [[ "$command" == *git-purge-ignored.sh ]]; then
			continue
		fi

		run "$command"
		if [ "$status" -ne 2 ]; then
			echo "$command returned $status instead of 2: $output" >&2
			return 1
		fi
	done
}

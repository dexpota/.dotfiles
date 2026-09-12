#!/usr/bin/env bats

command="$BATS_TEST_DIRNAME/../../../scripts/.scripts/pdf-decrypt"

@test "prints usage with help" {
	run "$command" --help

	[ "$status" -eq 0 ]
	[[ "$output" == Usage:* ]]
}

@test "requires input and output paths" {
	run "$command"

	[ "$status" -eq 2 ]
	[[ "$output" == Usage:* ]]
}

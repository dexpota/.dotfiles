#!/usr/bin/env bats

setup() {
	headers_file=$(mktemp)
	command="$BATS_TEST_DIRNAME/../../../scripts/.scripts/split-link-headers"
	cat > "$headers_file" <<'EOF'
HTTP/2 200
Link: <https://example.test/items?page=1>; rel="first", <https://example.test/items?page=2>; rel="prev", <https://example.test/items?page=4>; rel="next", <https://example.test/items?page=10>; rel="last"
EOF
}

teardown() {
	rm -f "$headers_file"
}

@test "extracts each requested pagination relation" {
	run "$command" "$headers_file" next first last prev

	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "https://example.test/items?page=4" ]
	[ "${lines[1]}" = "https://example.test/items?page=1" ]
	[ "${lines[2]}" = "https://example.test/items?page=10" ]
	[ "${lines[3]}" = "https://example.test/items?page=2" ]
}

@test "rejects unsupported relations" {
	run "$command" "$headers_file" alternate

	[ "$status" -eq 2 ]
	[[ "$output" == *"Unsupported relation: alternate"* ]]
}

@test "rejects missing header files" {
	run "$command" "$headers_file.missing" next

	[ "$status" -eq 1 ]
	[[ "$output" == *"Cannot read headers file"* ]]
}

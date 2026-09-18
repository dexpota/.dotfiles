#!/usr/bin/env bats

setup() {
    repository_root="$BATS_TEST_DIRNAME/../.."
    test_home="$(mktemp -d)"
    mock_bin="$test_home/bin"
    mkdir -p "$mock_bin"
    mock_codex="$mock_bin/codex"
    printf '%s\n' '#!/usr/bin/env sh' 'printf "%s|%s\\n" "$CODEX_HOME" "$*"' > "$mock_codex"
    chmod +x "$mock_codex"
}

teardown() {
    rm -rf "$test_home"
}

@test "codex-toolbelt uses its profile and starts from HOME in Bash" {
    run env HOME="$test_home" PATH="$mock_bin:$PATH" bash --noprofile --norc -c \
        '. "$1"; codex-toolbelt inspect' _ "$repository_root/bash/.bash/functions.bash"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_home/.codex-toolbelt|--cd $test_home inspect" ]

    run env HOME="$test_home" bash --noprofile --norc -c '. "$1"; alias ctb' _ \
        "$repository_root/bash/.bash/functions.bash"
    [ "$status" -eq 0 ]
    [ "$output" = "alias ctb='codex-toolbelt'" ]
}

@test "codex-toolbelt uses its profile and starts from HOME in Zsh" {
    run env HOME="$test_home" PATH="$mock_bin:$PATH" zsh -f -c \
        '. "$1"; codex-toolbelt inspect' _ "$repository_root/zsh/.zsh/functions.zsh"

    [ "$status" -eq 0 ]
    [ "$output" = "$test_home/.codex-toolbelt|--cd $test_home inspect" ]

    run env HOME="$test_home" zsh -f -c '. "$1"; alias ctb' _ \
        "$repository_root/zsh/.zsh/functions.zsh"
    [ "$status" -eq 0 ]
    [ "$output" = "ctb=codex-toolbelt" ]
}

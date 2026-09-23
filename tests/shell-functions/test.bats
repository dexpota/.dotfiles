#!/usr/bin/env bats

setup() {
    functions_file="$BATS_TEST_DIRNAME/../../shell/.shell/functions.sh"
    test_home="$(mktemp -d)"
    mkdir -p "$test_home/.shell"
    ln -s "$functions_file" "$test_home/.shell/functions.sh"
}

teardown() {
    rm -rf "$test_home"
}

@test "shared functions load and encode URLs in Bash" {
    run bash -c '
        . "$1"
        [ "$(urlencode "a b+")" = "a%20b%2B" ]
        [ "$(urldecode "a%20b%2B")" = "a b+" ]
        declare -F cless load_env >/dev/null
    ' _ "$functions_file"

    [ "$status" -eq 0 ]
}

@test "shared functions load and encode URLs in Zsh" {
    run zsh -fc '
        . "$1"
        [ "$(urlencode "a b+")" = "a%20b%2B" ]
        [ "$(urldecode "a%20b%2B")" = "a b+" ]
        (( $+functions[cless] && $+functions[load_env] ))
    ' _ "$functions_file"

    [ "$status" -eq 0 ]
}

@test "Bash and Zsh compatibility entry points load the shared library" {
    run env HOME="$test_home" bash -c '. "$1"; declare -F cless load_env >/dev/null' _ \
        "$BATS_TEST_DIRNAME/../../bash/.bash/functions.bash"
    [ "$status" -eq 0 ]

    run env HOME="$test_home" zsh -fc '. "$1"; (( $+functions[cless] && $+functions[load_env] ))' _ \
        "$BATS_TEST_DIRNAME/../../zsh/.zsh/functions.zsh"
    [ "$status" -eq 0 ]
}

@test "compatibility entry points load from a repository checkout" {
    run env HOME="$test_home" bash --noprofile --norc -c '. "$1"; declare -F cless load_env >/dev/null' _ \
        "$BATS_TEST_DIRNAME/../../bash/.bash/functions.bash"
    [ "$status" -eq 0 ]

    run env HOME="$test_home" zsh -f -c '. "$1"; (( $+functions[cless] && $+functions[load_env] ))' _ \
        "$BATS_TEST_DIRNAME/../../zsh/.zsh/functions.zsh"
    [ "$status" -eq 0 ]
}

#!/usr/bin/env bats

setup() {
    test_directory=$(mktemp -d)
    command="$BATS_TEST_DIRNAME/../../../git/.git-commands/git-tree"
    export GIT_CONFIG_NOSYSTEM=1
    export GIT_CONFIG_GLOBAL=/dev/null
    git init --quiet "$test_directory/repo"
    cd "$test_directory/repo"
    git config user.name "Test User"
    git config user.email "test@example.com"
    git checkout --quiet -b main
    git commit --quiet --allow-empty -m "Initial commit"
    git tag v1.0
    git update-ref refs/remotes/origin/main HEAD
    git checkout --quiet -b feature
    git commit --quiet --allow-empty -m "Feature with café and 日本語 and a deliberately long subject for truncation"
    git checkout --quiet main
    git commit --quiet --allow-empty -m "Main commit"
    git merge --quiet --no-ff feature -m "Merge feature"
}

teardown() {
    rm -rf "$test_directory"
}

@test "shows merge history and typed refs without ANSI when piped" {
    run "$command" --width=180
    [ "$status" -eq 0 ]
    [[ "$output" == *"HEAD"*"main"*"Merge feature"* ]]
    [[ "$output" == *"origin/main"*"v1.0"* || "$output" == *"v1.0"*"origin/main"* ]]
    [[ "$output" == *"Feature with café and 日本語"* ]]
    [[ "$output" != *$'\033'* ]]
}

@test "places hashes before refs and subjects and truncates wide text to fit" {
    run "$command" --width=55 --no-color
    [ "$status" -eq 0 ]
    [[ "$output" == *"…"* ]]
    printf '%s\n' "$output" | python3 -c '
import re, sys, unicodedata
commits = 0
for line in sys.stdin.read().splitlines():
    if "•" in line:
        assert re.match(r"[ │/\\•]*•[ │/\\]* [0-9a-f]{7,} ", line), line
        size = sum(0 if unicodedata.combining(c) else 2 if unicodedata.east_asian_width(c) in ("W", "F") else 1 for c in line)
        assert size <= 55, (size, line)
        assert not re.search(r" [0-9a-f]{7,}$", line), line
        commits += 1
assert commits == 4, commits
'
}

@test "supports forced color and removes ref namespace prefixes" {
    run "$command" --color=always --width=180
    [ "$status" -eq 0 ]
    [[ "$output" == *$'\033[48;5;211;'* ]]
    [[ "$output" == *$'\033[48;5;216;'* ]]
    [[ "$output" != *"refs/heads/"* ]]
    [[ "$output" != *"refs/tags/"* ]]
}

@test "passes history limits and path filters to Git" {
    run "$command" --no-color -1
    [ "$status" -eq 0 ]
    [[ "$output" == *"Merge feature"* ]]
    [[ "$output" != *"Initial commit"* ]]
    run "$command" --no-merges -- missing-file
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "adds optional Nerd Font icons to each ref type including detached HEAD" {
    run "$command" --icons --no-color --width=180
    [ "$status" -eq 0 ]
    [[ "$output" == *" HEAD"* ]]
    [[ "$output" == *" main"* ]]
    [[ "$output" == *" origin/main"* ]]
    [[ "$output" == *" v1.0"* ]]
    [[ "$output" != *$'\033'* ]]
    git checkout --quiet --detach
    run "$command" --icons -1
    [ "$status" -eq 0 ]
    [[ "$output" == *" HEAD"* ]]
    run "$command" --icons --no-icons --width=180
    [ "$status" -eq 0 ]
    [[ "$output" != *""* ]]
    [[ "$output" != *""* ]]
    [[ "$output" != *""* ]]
    [[ "$output" != *""* ]]
}

@test "preserves Git errors and rejects invalid presentation options" {
    run "$command" nonexistent-revision
    [ "$status" -ne 0 ]
    [[ "$output" == *"unknown revision"* ]]
    run "$command" --width=oops
    [ "$status" -eq 2 ]
    run "$command" --pretty=raw
    [ "$status" -eq 2 ]
    cd "$test_directory"
    run "$command"
    [ "$status" -ne 0 ]
    [[ "$output" == *"not a git repository"* ]]
}

@test "makes icon glyphs printable in the pager and preserves user overrides" {
    run python3 -c '
import os, runpy, subprocess, sys
command = sys.argv[1]
launcher = "import runpy, sys; sys.stdout.isatty = lambda: True; sys.argv = [sys.argv[1], \"--icons\", \"-1\"]; runpy.run_path(sys.argv[0], run_name=\"__main__\")"
env = dict(os.environ)
env["GIT_PAGER"] = "printf \"%s\\n\" \"$LESSUTFCHARDEF\"; cat"
env.pop("LESSUTFCHARDEF", None)
for override in (None, "f000-f8ff:w"):
    if override is not None:
        env["LESSUTFCHARDEF"] = override
    result = subprocess.run([sys.executable, "-c", launcher, command], env=env, capture_output=True, text=True, timeout=10)
    assert result.returncode == 0, (result.returncode, result.stderr)
    definition = result.stdout.splitlines()[0]
    if override is None:
        assert definition == "e0b4:p,e0b6:p,f024:p,f02b:p,f0c2:p,f126:p", definition
    else:
        assert definition == override, definition
    assert "Merge feature" in result.stdout, result.stdout
' "$command"
    [ "$status" -eq 0 ]
}

@test "less renders every icon literally in a terminal" {
    command -v less >/dev/null || skip "less is not installed"
    run python3 -c '
import errno, fcntl, os, pty, select, signal, struct, sys, termios, time
env = dict(os.environ)
env.update(GIT_PAGER="less", LESS="FRX", LESSCHARSET="utf-8", TERM="xterm-256color")
env.pop("LESSUTFCHARDEF", None)
pid, master = pty.fork()
if pid == 0:
    fcntl.ioctl(1, termios.TIOCSWINSZ, struct.pack("HHHH", 40, 200, 0, 0))
    os.execve(sys.argv[1], [sys.argv[1], "--icons", "--color=always", "--width=180"], env)
try:
    chunks = []
    deadline = time.monotonic() + 10
    while True:
        remaining = deadline - time.monotonic()
        if remaining <= 0 or not select.select([master], [], [], remaining)[0]:
            os.kill(pid, signal.SIGKILL)
            raise AssertionError("pager did not exit")
        try:
            chunk = os.read(master, 4096)
        except OSError as error:
            if error.errno == errno.EIO:
                break
            raise
        if not chunk:
            break
        chunks.append(chunk)
    output = b"".join(chunks).decode("utf-8")
    _, status = os.waitpid(pid, 0)
    assert status == 0, (status, output)
    assert "<U+" not in output, output
    for icon in ("\uf024", "\uf02b", "\uf0c2", "\uf126", "\ue0b4", "\ue0b6"):
        assert icon in output, output
finally:
    os.close(master)
' "$command"
    [ "$status" -eq 0 ]
}

@test "rounds colored icon labels and keeps plain output free of caps" {
    run "$command" --icons --color=always --width=180 -1
    [ "$status" -eq 0 ]
    [[ "$output" == *$'\033[38;5;211m\033[0m\033[48;5;211;38;5;235m'* ]]
    [[ "$output" == *$'\033[38;5;211m\033[0m'* ]]
    run "$command" --icons --no-color -1
    [ "$status" -eq 0 ]
    [[ "$output" == *" HEAD"* ]]
    [[ "$output" != *""* && "$output" != *""* ]]
    run "$command" --no-icons --color=always -1
    [ "$status" -eq 0 ]
    [[ "$output" != *""* && "$output" != *""* ]]
}

@test "handles detached HEAD and empty repositories" {
    git checkout --quiet --detach
    run "$command" -1
    [ "$status" -eq 0 ]
    [[ "$output" == *"HEAD"* ]]
    git init --quiet "$test_directory/empty"
    cd "$test_directory/empty"
    run "$command"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

#!/usr/bin/env bats

setup() {
    repository_root="$BATS_TEST_DIRNAME/../.."
    portable_scripts=(
        git/git-commands/git-branch-align.sh
        git/git-commands/git-branch-prune.sh
        git/git-commands/git-check-directories.sh
        git/git-commands/git-ignore.sh
        git/git-commands/git-purge-ignored.sh
        git/git-commands/git-purge-local-tracking-branches.sh
        git/git-commands/git-root.sh
        git/git-commands/git-sparse-checkout.sh
        scripts/.scripts/android-remote-connection
        scripts/.scripts/android-resource
        scripts/.scripts/boxes-tool
        scripts/.scripts/dupli
        scripts/.scripts/gh-curl-repo
        scripts/.scripts/gh-last-release
        scripts/.scripts/gh-last-release-asset
        scripts/.scripts/gh-last-release-assets
        scripts/.scripts/gh-list-tags
        scripts/.scripts/gh-md-toc
        scripts/.scripts/gl-repo-backup
        scripts/.scripts/gpg-export-keys
        scripts/.scripts/license
        scripts/.scripts/pdf-decrypt
        scripts/.scripts/shortcuts
        scripts/.scripts/spacey
        scripts/.scripts/split-link-headers
        scripts/.scripts/todo-hunt
        scripts/.scripts/wallabag-backup
        scripts/installation/nerd-fonts.sh
        scripts/installation/source-code-pro.sh
        scripts/installation/system-san-francisco.sh
    )
}

@test "ported commands parse in Bash and Zsh" {
    for script in "${portable_scripts[@]}"; do
        run bash -n "$repository_root/$script"
        [ "$status" -eq 0 ] || printf 'Bash failed to parse %s:\n%s\n' "$script" "$output"

        run zsh -n "$repository_root/$script"
        [ "$status" -eq 0 ] || printf 'Zsh failed to parse %s:\n%s\n' "$script" "$output"
    done
}

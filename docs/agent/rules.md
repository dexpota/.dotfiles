# Modification Rules

These rules apply to every repository change.

## Preserve User State

- Do not discard or rewrite unrelated working-tree changes.
- Inspect a target before editing it and keep changes limited to the requested scope.
- Treat Vim plugin submodules as third-party code; update the submodule reference instead of editing plugin contents directly.
- Do not run installation targets without considering their effects. Stow targets modify links under `$HOME`, and some recipes download software.

## Code and Naming Rules

- Use tabs for Make recipe lines and spaces for YAML indentation.
- Start executable shell scripts with an appropriate shebang and quote variable expansions.
- Give shell commands descriptive lowercase, hyphen-separated names, such as `git-branch-prune.sh`.
- Use `.sh` or `.bash` for non-executable shell libraries. Follow the existing convention in a directory for executable commands.
- Keep each Ansible task file focused on one tool or service and use lowercase kebab-case filenames.
- Preserve final newlines and remove trailing whitespace.

## Testing Rules

- Add regression coverage when changing behavior that has an existing test area.
- Name Bats files `*.bats`; place reusable fixtures in `helper.bash`.
- Isolate filesystem tests with `mktemp -d` and remove temporary state in `teardown`.
- Verify both exit status and meaningful output.
- Run the narrowest relevant test first, then the applicable repository-wide checks described in `development.md`.

## Documentation Rule

- Update the relevant documentation whenever a change affects behavior, commands, configuration, repository structure, setup steps, or contributor expectations.

## Commit and Pull Request Rules

- Use a short, imperative, sentence-case commit subject, for example `Add aliases` or `Fix quote issue`.
- Keep each commit limited to one configuration or behavior.
- Pull requests must identify the affected package, supported operating-system assumptions, and validation commands run.
- Document manual migration, relinking, or installation steps.
- Link related issues when available. Include screenshots only for visible terminal, prompt, or editor changes.

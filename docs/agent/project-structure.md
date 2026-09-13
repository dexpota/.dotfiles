# Project Structure

This repository manages personal Linux and macOS configuration with GNU Stow, Make, and Ansible.

- `bash/`, `zsh/`, `git/`, `vim/`, and `config/` are Stow packages whose contents mirror paths in the home directory.
- `local.yml` is the main Ansible playbook. Reusable provisioning steps and the macOS, Ubuntu, and Arch package inventory live in `tasks/`.
- `scripts/.scripts/` contains everyday commands exposed under `~/.scripts/` by Stow.
- `scripts/installation/` contains one-time setup helpers; do not expose these commands through the user's `PATH`.
- `scripts/.stow-local-ignore` makes Stow ignore everything in the package except the `.scripts/` directory.
- `git/git-commands/` contains custom Git subcommands.
- `tests/` contains Bats tests grouped by the command under test.
- `.hooks/` and `.pre-commit-config.yaml` define repository checks.
- Git submodules under `vim/.vim/bundle/` provide third-party plugins.

Place new files beside the feature they support. Add shell-command tests under a matching path in `tests/`; add provisioning logic as a focused task in `tasks/` and include it from `local.yml` when needed.

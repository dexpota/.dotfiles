# Development Workflow

## Discovery and Setup

- `make help` lists documented installation targets.
- `make git-submodule` initializes and updates Git submodules.
- `make bash`, `make zsh`, or `make git` installs a Stow package. `make git` requires `GITHUB_AUTHOR_NAME` and `GITHUB_AUTHOR_EMAIL`.
- `make vim` initializes the retained Vim package submodules at their pinned
  revisions, creates state directories, and restows the Vim configuration.

Installation targets can change files under `$HOME` or download tools. Inspect the relevant Make recipe before running one.

## Validation

- `ansible-playbook --syntax-check local.yml` validates the main playbook without provisioning a machine.
- `bats --recursive tests` runs every Bats suite in the repository.
- `bats tests/vim` checks Vim startup, filetypes, mappings, whitespace, and undo
  persistence in a temporary configuration. Package integration checks run when
  the retained submodules are initialized; Vim 8 or newer is required.
- `pre-commit run --all-files` checks whitespace, final newlines, shell naming, executable shebangs, and Makefile syntax.
- `make -n <target>` previews many Make recipes, although commands containing recursive Make or shell-side effects still require review.

GitHub Actions runs the complete Bats suite on every push and pull request. The CI environment adds `git/.git-commands` to `PATH` so tests can invoke repository commands.

Run checks relevant to the changed files. For shell behavior, run its Bats suite; for Ansible changes, run the syntax check; before handing off a broad change, run all configured pre-commit hooks.

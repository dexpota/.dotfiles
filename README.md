![.dotfiles](.github/banner.png)

# .dotfiles
> One repo to rule your machine.

This repository is a collection of configuration files and Ansible tasks I use
to setup my machine. The package inventory targets macOS, Ubuntu, and Arch.
Although these configurations are tailored for me, you can still find
some inspiration in them.

## Prerequisites

To use the configurations you need Make, Git, and GNU Stow. Provisioning also
requires a current Ansible installation with the `community.general` collection.
On macOS, install Homebrew and the Xcode Command Line Tools first. Homebrew and
user configuration run without sudo; Linux package installation uses sudo.

On Ubuntu:

```bash
sudo apt-get update
sudo apt-get install ansible git make stow
ansible-galaxy collection install community.general
```

## Installation and usage.

First you need to clone the repository in your home directory.

```bash
git clone git@github.com:dexpota/.dotfiles.git ~/.dotfiles
```
Then pull all submodules.

```bash
make git-submodule
```

Install the retained packages and basic user setup:

```bash
# Ubuntu / Arch (refresh the native package manager's indexes first)
ansible-playbook local.yml --ask-become-pass --tags packages,bash,git-lfs
# macOS
ansible-playbook local.yml --tags packages,bash,git-lfs
```

See [the provisioning inventory](docs/provisioning.md) for retained packages,
removed components, and remaining installer migration work.

After cloning the repository you can install the configuration files for your
program by using the `make` utility. For example you can install `git`'s
configurations file with this command.

```bash
# An example showing how to install git's configuration files.
make git
```

Shell configuration files can be installed in the same way:

```bash
make bash
make zsh
```

The Zsh target installs the Starship prompt in `~/.local/bin` when it is
missing, then links both the shell and Starship configuration files with GNU
Stow. The installer supports both macOS and Linux and requires either `curl`
or `wget`. The first prompt in each Zsh session shows its configuration
startup time.

## Git tree

`git tree` shows all branches with a colored terminal graph, labels for HEAD,
local branches, remote branches and tags, and commit hashes beside the graph dots.
Commit nodes use a small `•` bullet, with `│` for vertical graph lines.
Long subjects and labels are truncated to fit the terminal. Python 3 is required;
there are no additional Python dependencies. Rounded labels and curved graph
lines from graphical Git clients are approximated with terminal text and colors.

```bash
git tree -20
git tree --icons -20
git tree --since='2 weeks ago'
git tree --width=120 --color=always --no-pager
git tree -- src/
```

History filters, revisions and paths are forwarded to `git log`; options that
change its output format, such as `--pretty`, `--stat` and `-p`, are unsupported.
As with the previous alias, `--all --full-history` is enabled by default.
Interactive output uses Git's configured pager; redirected output omits color.
`NO_COLOR` disables automatic coloring, and `COLUMNS` overrides terminal width.

`--icons` adds a flag for HEAD, a branch symbol for local branches, a cloud for
remotes, and a tag symbol for tags. Colored labels also use Powerline rounded
caps to form pill-shaped badges; caps are omitted when color is disabled.
Configure your terminal to use a Nerd Font
Mono face so these glyphs occupy one character cell. Font support is not
auto-detected; icons are off by default and `--no-icons` explicitly disables them.
Ref names remain visible with icons enabled, including when color is disabled.
When icons are enabled, the pager receives a default `LESSUTFCHARDEF` declaring
the icon glyphs printable, preventing `less` from showing codes like `<U+F0C2>`.
An existing `LESSUTFCHARDEF` is preserved; `--no-pager` bypasses the pager entirely.

The old `tree` alias has been removed from the repository configuration so Git
can find the new command in `~/.git-commands`. For an existing installation,
run `stow git` from this repository and ensure `~/.git-commands` is on `PATH`.
If your Git configuration is a separate copy, remove its old alias with
`git config --global --unset alias.tree` after linking the command. A conflicting
copied configuration must be reconciled before Stow can link it.
Preview without installing using `./git/.git-commands/git-tree -20`.

## Vim

Make owns Vim directory creation, Pathogen installation, and YouCompleteMe
compilation. Install the Python 3/CMake build prerequisites above and a Rust
toolchain before running:

```bash
cd ~/.dotfiles
make vim
```

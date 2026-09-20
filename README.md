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

## Vim

Make owns Vim directory creation, Pathogen installation, and YouCompleteMe
compilation. Install the Python 3/CMake build prerequisites above and a Rust
toolchain before running:

```bash
cd ~/.dotfiles
make vim
```

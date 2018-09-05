# .dotfiles

This repository is a collection of configuration files and Ansible tasks I use
to setup my machine. These files are mainly targeted to work with Ubuntu and
Arch. Although these configurations are tailored for me, you can still find
some inspiration in them.

## Prerequisites

Ansible(at least 2.5.5), Make, git

```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update && sudo apt-get install ansible
```

## Installation and usage.

First you need to clone the repository in your home directory.

```bash
git clone git@github.com:dexpota/.dotfiles.git ~/.dotfiles 
```

After cloning the repository you can install the configuration files for your
program by using the `make` utility. For example you can install `git`'s
configurations file with this command.

```bash
# An example showing how to install git's configuration files.
make git
```
## Todo

- **vim**: Check vim installation to make it easier, now to install vim
  configuration files you need to execute these commands:

```bash
cd ~/.dotfiles
ansible-playbook local.yml --tags=pathogen,vim
make ycm
stow vim
```

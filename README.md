# .dotfiles

> One repo to rule your machine.

This repository is a collection of configuration files and Ansible tasks I use
to setup my machine. These files are mainly targeted to work with Ubuntu and
Arch. Although these configurations are tailored for me, you can still find
some inspiration in them.

## Prerequisites

To start using the configurations in this repository you will need: ansible (at
least 2.5.5), make and git. The following instructions shows how to install
them on Ubuntu.

```bash
# installing ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update && sudo apt-get install ansible
# installing git and make
sudo apt-get install git make
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

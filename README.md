# .dotfiles

This repository is a collection of configuration files and Ansible tasks I use to setup my machine. These files are mainly targeted to work with Ubuntu and Arch. Although these configurations are tailored for me, you can still find some inspiration in them.

## Prerequisites

Ansible version 2.5.5

```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update && sudo apt-get install ansible
```

## Installation and usage.

```bash
git clone git@github.com:dexpota/.dotfiles.git ~/.dotfiles 
```


```bash
# An example showing how to install git's configuration files.
cd ~/.dotfiles && stow git
```

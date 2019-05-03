#!/usr/bin/env bash

# Use the following solution if you want to keep the same kitty processs
# kitty @new-window --title tasks --keep-focus
# kitty @send-text -m title:tasks task\\x0d
kitty --session taskwarrior.conf

export PATH := $(shell pwd)/../scripts:$(PATH)
export PATH := $(shell pwd)/../scripts/.scripts:$(PATH)
export PATH := $(shell pwd)/../scripts/installation:$(PATH)
SHELL := env PATH=$(PATH) /bin/bash

all:
	@echo "${PATH}"
	system-san-francisco.sh
	source-code-pro.sh
	# TODO to be done
	# nerd-fonts.sh

#!/usr/bin/env bash

function install-plugin() {
	local directories=$1
	local retrive_function=$2

	shift 2
	local args=$@

	for config_directory in "${directories[@]}"
	do
		local plugin_directory="${config_directory}/config/plugins/"
  		
 		local zip=$($retrive_function $args)
		
		echo $zip

		unzip -d ${plugin_directory} ${zip}
	done
}

function retrieve-github {
	local tmp_dir=$(mktemp -d)

	wget -P ${tmp_dir} -q -i <(get-latest-release $1)

	local zips=(${tmp_dir}/*.zip)

	echo "${zips[0]}"
}

android_studio=(~/.AndroidStudio*)

install-plugin $android_studio retrieve-github halirutan/IntelliJ-Key-Promoter-X


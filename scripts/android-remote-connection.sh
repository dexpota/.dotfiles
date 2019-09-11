#!/usr/bin/env bash

# This script initalize adb for remote debugging.
#
# @author 	Fabrizio Destro <fabrizio@destro.dev>
# @license	GPL-3.0-or-later

# Select between all usb connected devices and retrieve its serial
serial=$(adb devices -l | sed -n "/usb:/p" | pick | cut -d' ' -f1)

# Extract android device ip
ip=$(adb -s "$serial" shell ip route | tr -s ' ' | cut -d' ' -f 9)

# Check a connection with the selected device already exists
if lsof -nP -i4TCP@"$ip":"$port" >/dev/null 2>&1; then
	exit 255
fi

# Search for the first free port starting from 5555 and counting
port=5555

while lsof -nP -i4TCP:"$port" >/dev/null 2>&1
do
	port=$((port + 1))
done

echo $port

adb -s "$serial" tcpip "$port"
adb -s "$serial" connect "$ip:$port"

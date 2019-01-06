#!/usr/bin/env bash

function android_screen_record() {
	local filename="$(mktemp -u -p "./").mp4"
	
	echo "Press CTRL+C to stop recording."
	adb shell screenrecord "/sdcard/$filename"
	adb pull "/sdcard/$filename"

	echo "Recording saved as $filename"
}

function android_screen_capture() {
	local filename="$(mktemp -u -p './').png"

	adb shell screencap -p "/sdcard/$filename"
	adb pull "/sdcard/$filename"

	echo "Capture saved as $filename"
}

function _get_android_sdk_root {
	case "$(uname -s)" in
		Darwin)
			echo "$HOME/Library/Android/sdk"
			;;
		Linux)
			echo "$HOME/Android/Sdk"
			;;
		*)
			echo ""
			;;
	esac
}

# if ANDROID_SDK is not set call _get_android_sdk_root and set a value.
ANDROID_SDK=${ANDROID_SDK-$(_get_android_sdk_root)}

# at this point ANDROID_SDK is set, we are going to set the other env variables.
ANDROID_SDK_PLATFORM_TOOLS=${ANDROID_SDK_PLATFORM_TOOLS-$ANDROID_SDK/platform-tools}
ANDROID_SDK_TOOLS=${ANDROID_SDK_TOOLS-$ANDROID_SDK/tools}

# export the env variable if the directory exist, else unset the variable.
if [ -d "$ANDROID_SDK" ]; then
	export ANDROID_SDK
else
	unset ANDROID_SDK
fi

if [ -d "$ANDROID_SDK_PLATFORM_TOOLS" ]; then
	export ANDROID_SDK_PLATFORM_TOOLS
	pathmunge "$ANDROID_SDK_PLATFORM_TOOLS"
else
	unset ANDROID_SDK_PLATFORM_TOOLS
fi

if [ -d "$ANDROID_SDK_TOOLS" ]; then
	export ANDROID_SDK_TOOLS
	pathmunge "$ANDROID_SDK_TOOLS"
else
	unset ANDROID_SDK_TOOLS
fi

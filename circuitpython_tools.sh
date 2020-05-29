#!/bin/bash

{

set -e # stop script on error

function help() {
    echo "\
Collection of tools to make working with CircuitPython boards easier.

Usage:
$(basename $0) -h       # show this message
$(basename $0) open     # open USB device in Finder
$(basename $0) build    # make _build folder, ready for deployment
$(basename $0) deploy   # actually deploy ^ to device
$(basename $0) watch    # watch for changes to automatically build and deploy
$(basename $0) serial   # connect to device's serial console
$(basename $0) eject    # eject/unmount USB drive so it can be unplugged

To get smaller build files, install mpy-cross and expose it to cpt:
export CPT_MPY_CROSS=\"/path/to/mpy-cross\"
"
}

COMMAND="$1"

if [ "$COMMAND" == '-h' ]; then
    help
    exit
fi

port=$(ls /dev/tty.usb*)
device="/Volumes/CIRCUITPY"
subject="main.py" # TODO: parameterize

function _compile_file() {
    path="$1"
    path_without_extension=$(echo "$path" | cut -f 1 -d '.')
    mpy_path="_build/$path_without_extension.mpy"

    echo "$path ->  $mpy_path"

    mkdir -p "$(dirname "$mpy_path")"
    $CPT_MPY_CROSS $path -o "$mpy_path"
}

function _build() {
    rm -rf "_build/"
    mkdir "_build/"

    if [ -z "$CPT_MPY_CROSS" ]; then
        # Plain copy stuff to _build, w/o actually building
        cp -rv "$subject" lib _build
    else
        # Compile .py files to _build/__.mpy
        for file in lib/*.py lib/**/*.py; do
            _compile_file "$file"
        done

        # Copy subject and any remaining .mpy files to _build
        for file in "$subject" lib/*.mpy lib/**/*.mpy; do
            cp -v "$file" "_build/$file"
        done
    fi
}

function _sync() {
    # Sync subject
    rsync \
        --archive --verbose --compress \
        "_build/$subject" \
        "$device"

    # Fully sync lib folder, deleting alien files
    rsync \
        --archive --verbose --compress --delete \
        "_build/lib/" \
        "$device/lib"
}

function _watch() {
    fsw -0 "$subject" "lib" | while read -d "" path
    do
        relative_path="${path#"$PWD/"}"

        if [ "$relative_path" == "$subject" ]; then
            cp -v "$relative_path" "_build/$relative_path"
        else
            _compile_file "$relative_path"
        fi

        _sync
    done
}

function _serial() {
    NAME="cpt_serial"
    screen -r "$NAME" || screen -S "$NAME" "$port" 115200
}

function _eject() {
    diskutil eject CIRCUITPY
}

function _open() {
  open "$device"
}

if [ -z "$COMMAND" ]; then
    help
    exit
fi

if [ -z "$port" ] || [ -z "$(test -d "$device" && echo .)" ]; then
    echo "Couldn't find device. Exiting."
    exit
else
    echo "Found device: $device at $port"
    echo
fi

if [ "$COMMAND" == "build" ]; then
    _build
elif [ "$COMMAND" == "open" ]; then
    _open
elif [ "$COMMAND" == "deploy" ]; then
    _build
    _sync
elif [ "$COMMAND" == "watch" ]; then
    _watch
elif [ "$COMMAND" == "serial" ]; then
    _serial
elif [ "$COMMAND" == "eject" ]; then
    _eject
else
    echo "Unkown command: $COMMAND"
fi

}

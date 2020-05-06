#!/bin/bash

{

function help() {
    echo "\
Collection of tools to make working with CircuitPython boards easier.

Usage:
$(basename $0) -h
$(basename $0) deploy
$(basename $0) watch
$(basename $0) serial"
}

COMMAND="$1"

if [ "$COMMAND" == '-h' ]; then
    help
    exit
fi

port=$(ls /dev/tty.usb*)
device="/Volumes/CIRCUITPY"
subject="main.py" # TODO: parameterize

function deploy() {
    echo "SYNCING"
    rsync \
        --archive --verbose --compress \
        "$subject" \
        /Volumes/CIRCUITPY/
}

function watch() {
    fsw -0 . | while read -d "" path
    do
        FILENAME=$(basename $path)

        if [ "$FILENAME" == "$subject" ]; then
            deploy
        fi
    done
}

function serial() {
    NAME="cpt_serial"
    screen -r "$NAME" || screen -S "$NAME" "$port" 115200
}

function eject() {
    diskutil eject CIRCUITPY
}

if [ -z "$port" ] || [ -z "$(test -d "$device" && echo .)" ]; then
    echo "Couldn't find device. Exiting."
    exit
else
    echo "Found device: $device at $port"
    echo
fi

if [ -z "$COMMAND" ]; then
    help
    exit
elif [ "$COMMAND" == "deploy" ]; then
    deploy
elif [ "$COMMAND" == "watch" ]; then
    watch
elif [ "$COMMAND" == "serial" ]; then
    serial
elif [ "$COMMAND" == "eject" ]; then
    eject
else
    echo "Unkown command: $COMMAND"
fi

}

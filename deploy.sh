#!/bin/bash

{

echo "BEFORE"
ls -l /Volumes/CIRCUITPY/

echo

echo "SYNCING"
rsync \
    --archive --verbose --compress \
    code.py \
    /Volumes/CIRCUITPY/

echo

echo "AFTER"
ls -l /Volumes/CIRCUITPY/

}

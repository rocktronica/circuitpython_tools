#!/bin/bash

{

fsw -0 . | while read -d "" path
do
    filename=$(basename $path)

    if [ "$filename" == 'code.py' ]; then
        ./deploy.sh
    fi
done

}

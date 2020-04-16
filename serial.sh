#!/bin/bash

{

port=$(ls /dev/tty.usb*)
screen "$port" 115200

}

#!/bin/bash

terminal=$1
current_pwd=$2

if [ "$current_pwd" == "/usr/bin" ]; then
  current_pwd="$HOME"
fi

echo "$terminal"

$terminal -D "$current_pwd"

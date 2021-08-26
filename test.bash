#!/bin/bash

command="wsl -d NixOs"

getOutput() {
  local inputVal="$1"
  echo $(inputVal)
}

output=$(getOutput command)

echo "$output"
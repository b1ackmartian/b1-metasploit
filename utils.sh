#!/usr/bin/env bash

fancy_echo() {
  local calling_script="$(basename "${BASH_SOURCE[1]}")"
  calling_script="${calling_script^^}"  # Convert to uppercase
  
  local color_code="\033[38;2;43;182;115m"
  local reset_code="\033[0m"
  
  local prefix="${color_code}[-- ${calling_script} --]${reset_code}"
  echo -e "${prefix} $@"
}
#!/usr/bin/env zsh

set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe

script=$(eza ~/.local/bin | fuzzel --dmenu --placeholder="pick a script to launch")

if [[ -z $script ]]; then
  notify-send "Exiting..."
  exit 1
fi

exec $script

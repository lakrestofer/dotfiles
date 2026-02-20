#!/usr/bin/env zsh

set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe

FREQ_MAP_NAME="script-menu"

# pick a script to exec, sort them based on common usage
script=$(eza ~/.local/bin | dmenu-hist.py sort "$FREQ_MAP_NAME" | fuzzel --dmenu --placeholder="pick a script to launch")

# increment the use count of the script we are going to exec
echo $script | dmenu-hist.py incr "$FREQ_MAP_NAME"

if [[ -z $script ]]; then
  notify-send "Exiting..."
  exit 1
fi

exec $script

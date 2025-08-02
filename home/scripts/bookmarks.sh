#!/usr/bin/env zsh

set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe

BOOKMARKS_FILE="/home/fincei/bookmarks"

bookmark=$(cat "$BOOKMARKS_FILE" | fuzzel --dmenu --lines=5 --prompt="bookmark: ")

if [[ -z $bookmark ]]; then
  notify-send "No bookmark. exiting..."
  exit 1
fi

notify-send "Typing out bookmark"
ydotool type "$bookmark"

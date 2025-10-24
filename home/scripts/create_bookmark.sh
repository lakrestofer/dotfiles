
#!/usr/bin/env zsh

# set -e # exit if any step has a nonzero exit code
# set -o pipefail # including in the middle of a pipe

BOOKMARKS_FILE="/home/fincei/bookmarks"

default=$(wl-paste --no-newline --primary 2>/dev/null || wl-paste --no-newline 2>/dev/null || echo "")

bookmark=$(fuzzel --dmenu --lines=0 --search $default --prompt="new bookmark: ")

if [[ -z $bookmark ]]; then
  notify-send "No bookmark. exiting..."
  exit 1
fi

notify-send "Adding line to bookmarks file"
echo -E "$bookmark" >> "$BOOKMARKS_FILE"


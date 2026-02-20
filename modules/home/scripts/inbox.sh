#!/usr/bin/env zsh

set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe

local INBOX_FILE="/home/fincei/vault/notes/inbox.md"

local default=$(wl-paste --no-newline --primary 2>/dev/null || wl-paste --no-newline 2>/dev/null || echo "")

local thought=$(fuzzel --dmenu --lines=0 --prompt="inbox: " --search "$default")

if [[ -z $thought ]]; then
  exit 1
fi

notify-send "Adding to inbox..."
echo -E "- $thought" >> $INBOX_FILE 


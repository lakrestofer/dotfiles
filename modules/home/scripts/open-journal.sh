#!/bin/sh

set -e
set -o pipefail

# Check if a journal window is already open
journal_window_id=$(niri msg --json windows | jq -r '.[] | select(.title == "markdown-journal") | .id' | head -1)

if [ -n "$journal_window_id" ]; then
  niri msg action focus-window --id "$journal_window_id"
  exit 0
fi

cd $ZK_NOTEBOOK_DIR

today=$(date '+%Y-%m')

ghostty --title="markdown-journal" -e zk edit "journal/$today"

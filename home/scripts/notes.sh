#!/bin/sh

set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe

cd $ZK_NOTEBOOK_DIR

# {{(format-date modified 'elapsed')}}
input=$(zk list \
  --quiet \
  --format='{{path}}\t{{title}}' \
  --exclude="journal" \
  --sort modified \
  | fuzzel \
  --dmenu \
  --placeholder='Ctrl-Return to create note immediately' \
  --with-nth=2 --accept-nth=1
)

echo "$input"

# exit on empty input
if [[ -z "${input//[[:space:]]/}" ]]; then
  exit 0
fi

# check if note exists by querying for path
if [[ $input != *.md ]]; then
  notify-send "creating note"
  ghostty +new-window -e zk new --no-input --title "$input"
  exit 0
fi

ghostty -e "zk" "edit" "$input"


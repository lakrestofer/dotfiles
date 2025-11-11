#!/bin/sh


set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe

cd $ZK_NOTEBOOK_DIR

# if the current month is after the month of the last note
# then create a new journal note for this month
today=$(date '+%Y-%m')
has_journal=$(zk list --quiet --format {{path}} --no-pager --sort path- "journal/$today")

if [[ -z has_journal ]]; then
  notify-send "journal entry for this month did not exist, creating"
  exit 0
fi

input=$(zk list journal\
  --quiet \
  --format='{{path}}\t{{title}}' \
  --sort path- \
  | fuzzel \
  --dmenu \
  --with-nth=2 --accept-nth=1
)

# exit on empty input
if [[ -z "${input//[[:space:]]/}" ]]; then
  exit 0
fi

# check if note exists by querying for path
if [[ $input != *.md ]]; then
  notify-send "No journal entry with that name!"
  exit 0
fi

ghostty -e zk edit $input

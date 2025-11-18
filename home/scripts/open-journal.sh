#!/bin/sh


set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe

cd $ZK_NOTEBOOK_DIR

today=$(date '+%Y-%m')

ghostty --title="markdown-journal" -e zk edit "journal/$today"

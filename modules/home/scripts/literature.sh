#!/usr/bin/env zsh

set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe


FREQ_MAP_NAME="script-menu"

# file=$(eza ~/vault/literature --color=never --sort=accessed --reverse| dmenu-hist.py sort "$FREQ_MAP_NAME" | fuzzel --dmenu)

# echo $file | dmenu-hist.py incr "$FREQ_MAP_NAME"
file=$(eza ~/vault/literature --color=never --sort=accessed --reverse | fuzzel --dmenu)
# echo $file | dmenu-hist.py incr "$FREQ_MAP_NAME"

zathura "~/vault/literature/$file"

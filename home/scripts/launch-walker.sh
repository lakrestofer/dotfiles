#!/usr/bin/env zsh
set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe

nc -U /run/user/1000/walker/walker.sock

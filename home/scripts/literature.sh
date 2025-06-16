#!/bin/sh

result=$(cd ~/Library && ls | fuzzel --dmenu --lines=5 --width=80% --matching=fuzzy)

echo "/home/fincei/Library/"$result

[[ $result ]] && xdg-open "/home/fincei/Library/"$result

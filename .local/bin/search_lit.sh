#!/bin/sh

result=$(ls ~/Library/* | wofi --dmenu --lines=5 --width=80% --matching=fuzzy)

echo $result

[[ $result ]] && xdg-open $result

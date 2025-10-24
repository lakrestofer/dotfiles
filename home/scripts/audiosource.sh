#!/bin/sh

set -e # exit if any step has a nonzero exit code
set -o pipefail # including in the middle of a pipe

# Create a list of sinks with pretty names
options=$(pactl -f json list sinks | jq -r '.[] | .description')

# Let the user select a description
selection=$(echo "$options" | fuzzel --dmenu --placeholder='Select audio source')

# Extract the corresponding sink name
sink_name=$(pactl -f json list sinks | jq -r --arg sink_pretty_name "$selection" '.[] | select(.description == $sink_pretty_name) | .name')

# Set the selected sink as default
if [ -n "$sink_name" ]; then
    pactl set-default-sink "$sink_name" && notify-send "Audio switched to: $selection"
else
    notify-send "Audio switch failed"
fi

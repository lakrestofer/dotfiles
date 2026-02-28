#!/usr/bin/env zsh

# Read battery status and capacity
bat_status=$(cat /sys/class/power_supply/BAT0/status)
capacity=$(cat /sys/class/power_supply/BAT0/capacity)

# Check if battery is not charging and capacity is low
if [[ "$bat_status" != "Charging" ]] && [[ $capacity -lt 10 ]]; then
    battery_notification.py
fi

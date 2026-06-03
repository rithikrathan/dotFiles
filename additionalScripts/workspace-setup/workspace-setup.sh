#!/bin/bash

CONFIG_FILE="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)/config.json"

if [[ ! -f "$CONFIG_FILE" ]]; then
    notify-send -u critical "Workspace Setup" "config.json not found"
    exit 1
fi

selected=$(jq -r '.[].name' "$CONFIG_FILE" | rofi -dmenu -p "Workspace Setup")
[[ -z "$selected" ]] && exit 0

preset=$(jq -c --arg sel "$selected" '.[] | select(.name == $sel)' "$CONFIG_FILE")
[[ -z "$preset" ]] && exit 1

echo "$preset" | jq -c '.apps[]' | while read -r app; do
    ws=$(echo "$app" | jq -r '.w')
    cmd=$(echo "$app" | jq -r '.cmd')

    hyprctl dispatch workspace "$ws"
    sleep 0.15
    hyprctl dispatch exec "$cmd"
    sleep 0.4
done

first_ws=$(echo "$preset" | jq -r '.apps[0].w')
hyprctl dispatch workspace "$first_ws"

notify-send "Workspace Setup" "\"$selected\" ready"

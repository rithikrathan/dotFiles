#!/bin/bash

CONFIG_FILE="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)/config.json"

if [[ ! -f "$CONFIG_FILE" ]]; then
    notify-send -u critical "Workspace Setup" "config.json not found"
    exit 1
fi

options="$(printf "close(forced)\n%s" "$(jq -r '.[].name' "$CONFIG_FILE")")"
selected=$(echo "$options" | rofi -dmenu -i -p "Workspace Setup")
[[ -z "$selected" ]] && exit 0

if [[ "$selected" == "close(forced)" ]]; then
    hyprctl clients -j | jq -r '.[].address' | while read -r addr; do
        hyprctl dispatch closewindow "address:$addr"
    done
    notify-send "Workspace Setup" "All windows closed (forced)"
    exit 0
fi

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

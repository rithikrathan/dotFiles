#!/bin/bash

CONFIG_FILE="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)/config.json"

if [[ ! -f "$CONFIG_FILE" ]]; then
    notify-send -u critical "Workspace Setup" "config.json not found"
    exit 1
fi

declare -A ICONS
ICONS["Game Dev"]=""
ICONS["Minimal"]=""
ICONS["Coding"]=""
ICONS["Meeting"]=""
ICONS["3D"]=""
ICONS["Writing"]=""
ICONS["Study"]=""
ICONS["Dev Tools"]=""
ICONS["Design"]=""
ICONS["close(forced)"]=""

icon_for() {
    echo "${ICONS[$1]:- }"
}

options=""
while IFS= read -r name; do
    icon=$(icon_for "$name")
    options="${options}${icon}     ${name}\n"
done < <(printf "close(forced)\n%s" "$(jq -r '.[].name' "$CONFIG_FILE")")
options="${options%\\n}"

pkill -x bemenu 2>/dev/null

selected=$(echo -e "$options" | bemenu-caelestia -l 8 -c -W 0.38)

[[ -z "$selected" ]] && exit 0

selected="${selected##* }"

if [[ "$selected" == "close(forced)" ]]; then
    hyprctl clients -j | jq -r '.[].address' | while read -r addr; do
        hyprctl dispatch closewindow "address:$addr"
    done
    notify-send "Workspace Setup" "All windows closed (forced)"
    exit 0
fi

preset=$(jq -c --arg sel "$selected" '.[] | select(.name == $sel)' "$CONFIG_FILE")
[[ -z "$preset" ]] && exit 1

first_ws=$(echo "$preset" | jq -r '.apps[0].w')

echo "$preset" | jq -c '.apps[]' | while read -r app; do
    ws=$(echo "$app" | jq -r '.w')
    cmd=$(echo "$app" | jq -r '.cmd')
    hyprctl dispatch workspace "$ws"
    sleep 0.15
    hyprctl dispatch exec "$cmd"
    sleep 0.4
done

summary=$(echo "$preset" | jq -r '.apps[] | .cmd | split(" ") | last | split("/") | last')

hyprctl dispatch workspace "$first_ws"
notify-send "Workspace Setup" "$selected
$summary"

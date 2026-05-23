#!/bin/bash
BAT_PATH="/sys/class/power_supply/BAT0"

status=$(cat "$BAT_PATH/status" 2>/dev/null)
capacity=$(cat "$BAT_PATH/capacity" 2>/dev/null)
threshold=$(cat "$BAT_PATH/charge_control_end_threshold" 2>/dev/null)

[ -z "$capacity" ] && capacity=0
[ -z "$threshold" ] && threshold=100

TC='#e02840'
G4='#9e9e9e'

if [ "$status" = "Charging" ] && [ "$threshold" -lt 100 ] 2>/dev/null; then
    icon="󰢟"
elif [ "$status" = "Charging" ]; then
    icon="󰂄"
elif [ "$status" = "Full" ] || [ "$status" = "Not charging" ]; then
    icon="󰁹"
elif [ "$capacity" -le 15 ]; then
    icon="󰁺"
else
    icon="󰁾"
fi

echo "#[fg=$TC]$icon #[fg=$G4]$capacity%"

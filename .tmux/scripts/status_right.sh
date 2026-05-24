#!/bin/bash
TC='#e02840'
G4='#9e9e9e'

INDEX=$(tmux show-option -gv @status_cycle_index 2>/dev/null || echo 0)

items=()
items+=("bat")

for p in /dev/ttyACM* /dev/ttyUSB*; do
    [ -e "$p" ] && items+=("ser:$(basename "$p")")
done
[ ${#items[@]} -eq 1 ] && items+=("ser:0")

TOTAL=${#items[@]}
ITEM="${items[$(( INDEX % TOTAL ))]}"

case "$ITEM" in
    bat)
        d="/sys/class/power_supply/BAT0"
        s=$(cat "$d/status" 2>/dev/null)
        c=$(cat "$d/capacity" 2>/dev/null)
        t=$(cat "$d/charge_control_end_threshold" 2>/dev/null)
        c=${c:-0}; t=${t:-100}
        if [ "$s" = "Charging" ] && [ "$t" -lt 100 ] 2>/dev/null; then i="󰢟"
        elif [ "$s" = "Charging" ]; then i="󰂄"
        elif [ "$s" = "Full" ] || [ "$s" = "Not charging" ]; then i="󰁹"
        elif [ "$c" -le 15 ]; then i="󰁺"
        else i="󰁾"
        fi
        echo "#[fg=$TC]$i #[fg=$G4]$c%"
        ;;
    ser:0)
        echo "#[fg=$TC]󰕓 #[fg=$G4]none"
        ;;
    ser:*)
        n="${ITEM#ser:}"
        echo "#[fg=$TC]󰕓 #[fg=$G4]$n"
        ;;
esac

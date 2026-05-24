#!/bin/bash
CACHE="/tmp/tmux_nowplaying"
TC='#e02840'
G4='#9e9e9e'

[ -f "$CACHE" ] && [ $(( $(date +%s) - $(date -r "$CACHE" +%s 2>/dev/null || echo 0) )) -lt 5 ] && cat "$CACHE" && exit

MUSIC=$(timeout 1 playerctl metadata --format "{{artist}} - {{title}}" 2>/dev/null)
if [ -z "$MUSIC" ]; then
    echo "#[fg=$TC]󰎆 #[fg=$G4]stopped" > "$CACHE"
else
    [ ${#MUSIC} -gt 45 ] && MUSIC="${MUSIC:0:42}..."
    echo "#[fg=$TC]󰎆 #[fg=$G4]$MUSIC" > "$CACHE"
fi
cat "$CACHE"

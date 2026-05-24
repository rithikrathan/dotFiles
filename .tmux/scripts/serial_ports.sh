#!/bin/bash
TC='#e02840'
G4='#9e9e9e'
PORTS=""
for p in /dev/ttyACM* /dev/ttyUSB*; do
    [ -e "$p" ] && PORTS="$PORTS $(basename "$p")"
done
PORTS=$(echo "$PORTS" | xargs)
if [ -z "$PORTS" ]; then
    echo "#[fg=$TC]󰈑 #[fg=$G4]none"
else
    echo "#[fg=$TC]󰈑 #[fg=$G4]$PORTS"
fi

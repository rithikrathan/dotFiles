#!/bin/bash

total=1

ports_found=0
for p in /dev/ttyACM* /dev/ttyUSB*; do
    [ -e "$p" ] && ports_found=$((ports_found + 1))
done

if [ "$ports_found" -gt 0 ]; then
    total=$((total + ports_found))
else
    total=$((total + 1))
fi


INDEX=$(tmux show-option -gv @status_cycle_index 2>/dev/null || echo 0)
NEXT=$(( (INDEX + 1) % total ))
tmux set-option -g @status_cycle_index $NEXT

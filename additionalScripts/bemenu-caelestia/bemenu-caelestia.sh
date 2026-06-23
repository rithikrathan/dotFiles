#!/bin/bash

accent="#db293f"
bg="#060505"
searchBg="#1c1c1c"
fg="#d0c0c0"

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    return
fi

exec bemenu \
    --nb "$bg" --nf "$fg" \
    --tb "$bg" --tf "$accent" \
    --fb "$searchBg" --ff "$fg" \
    --hb "$accent" --hf "#000000" \
    --cb "$accent" --cf "#000000" \
    --ab "$bg" --af "$fg" \
    --scb "$searchBg" --scf "$accent" \
    --bdr "$accent" -B 4 -R 8 -W 0.3 -c \
    -p "WS Presets:" -s --hp 0 -i \
    --fn "JetBrainsMono Nerd Font Medium 20" -H 32 \
    "$@"

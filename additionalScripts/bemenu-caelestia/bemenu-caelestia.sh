#!/bin/bash

_caelestia_color() {
    caelestia scheme get 2>/dev/null | sed -n "s/^[[:space:]]*$1:.*\[[0-9;]*m\([0-9a-fA-F]\{6\}\).*/\1/p" | head -1
}

_dim_color() {
    local hex=$1 factor=$2
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    r=$(awk "BEGIN{printf \"%d\", $r * $factor}")
    g=$(awk "BEGIN{printf \"%d\", $g * $factor}")
    b=$(awk "BEGIN{printf \"%d\", $b * $factor}")
    [ $r -gt 255 ] && r=255
    [ $g -gt 255 ] && g=255
    [ $b -gt 255 ] && b=255
    printf "#%02x%02x%02x\n" $r $g $b
}

onSurface=$(_caelestia_color onSurface)
onPrimary=$(_caelestia_color onPrimary)
surfaceContainerLowest=$(_caelestia_color surfaceContainerLowest)
surfaceDim=$(_caelestia_color surfaceDim)
onSecondary=$(_caelestia_color onSecondary)

[ -z "$onSurface" ] && onSurface="f8e0e0"
[ -z "$onPrimary" ] && onPrimary="404040"
[ -z "$surfaceContainerLowest" ] && surfaceContainerLowest="000000"
[ -z "$surfaceDim" ] && surfaceDim="130c0d"
[ -z "$onSecondary" ] && onSecondary="553a2e"

onSurface="${onSurface#\#}"
onPrimary="${onPrimary#\#}"
surfaceContainerLowest="${surfaceContainerLowest#\#}"
surfaceDim="${surfaceDim#\#}"
onSecondary="${onSecondary#\#}"

normalBg="#$surfaceDim"
normalFg=$(_dim_color "$onPrimary" 2.5)

titleBg="#$onPrimary"
titleFg="$normalFg"

filterBg="#$onPrimary"
filterFg="$normalFg"

highlightBg=$(_dim_color "$onPrimary" 2.0)
highlightFg="$normalBg"

cursorBg="$highlightBg"
cursorFg="$normalBg"

altBg="$normalBg"
altFg="$normalFg"

scrollbarBg="#$surfaceContainerLowest"
scrollbarFg="$normalFg"

border="$highlightBg"

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    return
fi

exec bemenu \
    --nb "$normalBg" --nf "$normalFg" \
    --tb "$titleBg" --tf "$titleFg" \
    --fb "$filterBg" --ff "$filterFg" \
    --hb "$highlightBg" --hf "$highlightFg" \
    --cb "$cursorBg" --cf "$cursorFg" \
    --ab "$altBg" --af "$altFg" \
    --scb "$scrollbarBg" --scf "$scrollbarFg" \
    --bdr "$border" -B 4 -R 8 \
    -p "WS Presets:" -s --hp 0 -i \
    --fn "JetBrainsMono Nerd Font Medium 20" -H 32 \
    "$@"

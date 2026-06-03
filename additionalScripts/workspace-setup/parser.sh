#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
LIST_FILE="$DIR/workspace.list"
PADDED=$(printf '%0.1s' ' '{1..60})

if [[ ! -f "$LIST_FILE" ]]; then
    exit 0
fi

while IFS=: read -r modkey key action desc || [[ -n "$modkey" ]]; do
    [[ -z "$modkey" || "$modkey" =~ ^# ]] && continue

    action="${action// /}"

    [[ -z "$modkey" || -z "$key" || -z "$action" ]] && continue

    printf "bind = %s, %s, exec, %s\n" "$modkey" "$key" "$action"
done < "$LIST_FILE"

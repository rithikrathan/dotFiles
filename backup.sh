#!/bin/bash

LIST_FILE="target.list"
# Text formatting
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

if [[ ! -f "$LIST_FILE" ]]; then
    echo "Error: $LIST_FILE not found!"
    exit 1
fi

# Count total items for the progress counter
TOTAL_ITEMS=$(grep -cv '^#\|^$' "$LIST_FILE")
CURRENT_ITEM=0

echo "${BOLD}== Starting Dotfiles Sync ==${NORMAL}"
echo "---------------------------------------"

while IFS=: read -r src dest || [[ -n "$src" ]]; do
    # Skip comments and empty lines
    [[ -z "$src" || "$src" =~ ^# ]] && continue
    
    ((CURRENT_ITEM++))
    PERCENT=$(( CURRENT_ITEM * 100 / TOTAL_ITEMS ))

    if [[ -e "$src" ]]; then
        echo -e "\n${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%] Syncing:${NORMAL} $src"
        
        if [[ -d "$src" ]]; then
            rsync -av --delete --info=progress2 "${src%/}/" "$dest/"
        else
            rsync -av --info=progress2 "$src" "$dest"
        fi
    else
        echo -e "[!] Skip: $src (Source not found)"
    fi
done < "$LIST_FILE"

echo -e "\n---------------------------------------"
echo "${BOLD}>> Sync Complete.${NORMAL}"

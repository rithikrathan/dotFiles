#!/bin/bash

LIST_FILE="target.list"
# Text formatting
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

MODE="export"  # default mode

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e)
            MODE="export"
            shift
            ;;
        -i)
            MODE="import"
            shift
            ;;
        *)
            echo "Usage: $0 [-e|-i]"
            echo "  -e : Export mode (backup from system to dotfiles, default)"
            echo "  -i : Import mode (restore from dotfiles to system)"
            exit 1
            ;;
    esac
done

if [[ ! -f "$LIST_FILE" ]]; then
    echo "Error: $LIST_FILE not found!"
    exit 1
fi

# Count total items for the progress counter
TOTAL_ITEMS=$(grep -cv '^#\|^$' "$LIST_FILE")
CURRENT_ITEM=0

if [[ "$MODE" == "export" ]]; then
    echo "${BOLD}== Starting Dotfiles Export (System → Local) ==${NORMAL}"
else
    echo "${BOLD}== Starting Dotfiles Import (Local → System) ==${NORMAL}"
fi
echo "---------------------------------------"

while IFS=: read -r src dest || [[ -n "$src" ]]; do
    # Skip comments and empty lines
    [[ -z "$src" || "$src" =~ ^# ]] && continue
    
    ((CURRENT_ITEM++))
    PERCENT=$(( CURRENT_ITEM * 100 / TOTAL_ITEMS ))

    if [[ "$MODE" == "export" ]]; then
        # Export mode: System → Local (original behavior)
        if [[ -e "$src" ]]; then
            echo -e "\n${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%] Exporting:${NORMAL} $src → $dest"
            
            if [[ -d "$src" ]]; then
                rsync -av --delete --info=progress2 "${src%/}/" "$dest/"
            else
                rsync -av --info=progress2 "$src" "$dest"
            fi
        else
            echo -e "[!] Skip: $src (Source not found)"
        fi
    else
        # Import mode: Local → System (reverse)
        if [[ -e "$dest" ]]; then
            echo -e "\n${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%] Importing:${NORMAL} $dest → $src"
            
            if [[ -d "$dest" ]]; then
                rsync -av --delete --info=progress2 "${dest%/}/" "$src/"
            else
                rsync -av --info=progress2 "$dest" "$src"
            fi
        else
            echo -e "[!] Skip: $dest (Source not found)"
        fi
    fi
done < "$LIST_FILE"

echo -e "\n---------------------------------------"
echo "${BOLD}>> Sync Complete.${NORMAL}"

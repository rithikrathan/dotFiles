#!/bin/bash

LIST_FILE="target.list"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

MODE=""

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
        -as)
            MODE="add_symlink"
            shift
            ;;
        -ds)
            MODE="delete_symlink"
            shift
            ;;
        *)
            echo "Usage: $0 [-e|-i|-as|-ds]"
            echo "  -e  : Export (system → local, via rsync)"
            echo "  -i  : Import (local → system, via rsync)"
            echo "  -as : Add symlinks (system → repo)"
            echo "  -ds : Delete symlinks (remove those created by -as)"
            exit 1
            ;;
    esac
done

if [[ -z "$MODE" ]]; then
    echo "Usage: $0 [-e|-i|-as|-ds]"
    exit 1
fi

if [[ ! -f "$LIST_FILE" ]]; then
    echo "Error: $LIST_FILE not found!"
    exit 1
fi

TOTAL_ITEMS=$(grep -cv '^#\|^$' "$LIST_FILE")
CURRENT_ITEM=0

case "$MODE" in
    export)
        echo "${BOLD}== Exporting (System → Local) ==${NORMAL}"
        echo "---------------------------------------"
        while IFS=: read -r src dest || [[ -n "$src" ]]; do
            [[ -z "$src" || "$src" =~ ^# ]] && continue
            ((CURRENT_ITEM++))
            PERCENT=$(( CURRENT_ITEM * 100 / TOTAL_ITEMS ))
            if [[ -e "$src" ]]; then
                echo -e "\n${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} $src → $dest"
                if [[ -d "$src" ]]; then
                    mkdir -p "$dest"
                    rsync -av --copy-links --delete --info=progress2 "${src%/}/" "$dest/"
                else
                    mkdir -p "$(dirname "$dest")"
                    rsync -av --copy-links --info=progress2 "$src" "$dest"
                fi
            else
                echo -e "[!] Skip: $src (Source not found)"
            fi
        done < "$LIST_FILE"
        ;;
    import)
        echo "${BOLD}== Importing (Local → System) ==${NORMAL}"
        echo "---------------------------------------"
        while IFS=: read -r src dest || [[ -n "$src" ]]; do
            [[ -z "$src" || "$src" =~ ^# ]] && continue
            ((CURRENT_ITEM++))
            PERCENT=$(( CURRENT_ITEM * 100 / TOTAL_ITEMS ))
            if [[ -e "$dest" ]]; then
                echo -e "\n${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} $dest → $src"
                if [[ -d "$dest" ]]; then
                    mkdir -p "$src"
                    rsync -av --copy-links --delete "${dest%/}/" "$src/"
                else
                    mkdir -p "$(dirname "$src")"
                    rsync -av --copy-links "$dest" "$src"
                fi
            else
                echo -e "[!] Skip: $dest (Source not found)"
            fi
        done < "$LIST_FILE"
        ;;
    add_symlink)
        echo "${BOLD}== Adding Symlinks (System → Repo) ==${NORMAL}"
        echo "---------------------------------------"
        while IFS=: read -r src dest || [[ -n "$src" ]]; do
            [[ -z "$src" || "$src" =~ ^# ]] && continue
            ((CURRENT_ITEM++))
            PERCENT=$(( CURRENT_ITEM * 100 / TOTAL_ITEMS ))
            repo_path="$SCRIPT_DIR/$dest"
            if [[ -L "$src" ]]; then
                current_target=$(readlink "$src")
                if [[ "$current_target" == "$repo_path" ]]; then
                    echo -e "${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} Already linked: $src"
                else
                    echo -e "${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} [!] $src is a symlink to a different target. Skipping."
                fi
            elif [[ -e "$src" ]]; then
                echo -e "\n${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} $src exists as a regular file/dir."
                read -p "  Replace with symlink to repo? [y/N] " -n 1 -r
                echo
                if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                    rm -rf "$src"
                    mkdir -p "$(dirname "$src")"
                    ln -s "$repo_path" "$src"
                    echo "  → Symlinked: $src → $repo_path"
                else
                    echo "  → Skipped."
                fi
            else
                mkdir -p "$(dirname "$src")"
                ln -s "$repo_path" "$src"
                echo -e "${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} Symlinked: $src → $repo_path"
            fi
        done < "$LIST_FILE"
        ;;
    delete_symlink)
        echo "${BOLD}== Deleting Symlinks ==${NORMAL}"
        echo "---------------------------------------"
        while IFS=: read -r src dest || [[ -n "$src" ]]; do
            [[ -z "$src" || "$src" =~ ^# ]] && continue
            ((CURRENT_ITEM++))
            PERCENT=$(( CURRENT_ITEM * 100 / TOTAL_ITEMS ))
            repo_path="$SCRIPT_DIR/$dest"
            if [[ -L "$src" ]]; then
                current_target=$(readlink "$src")
                if [[ "$current_target" == "$repo_path" ]]; then
                    unlink "$src"
                    echo -e "${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} Removed symlink: $src"
                else
                    echo -e "${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} [!] $src is a symlink to a different target. Skipping."
                fi
            elif [[ -e "$src" ]]; then
                echo -e "${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} [!] $src is a regular file/dir, not a symlink. Skipping."
            else
                echo -e "${BOLD}[$CURRENT_ITEM/$TOTAL_ITEMS - $PERCENT%]${NORMAL} [!] $src does not exist. Skipping."
            fi
        done < "$LIST_FILE"
        ;;
esac

echo -e "\n---------------------------------------"
echo "${BOLD}>> Done.${NORMAL}"

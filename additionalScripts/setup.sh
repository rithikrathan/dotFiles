#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
KEYBINDS_FILE="$DIR/keybinds.conf"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$BIN_DIR"

echo "=== additionalScripts Setup ==="
echo ""

> "$KEYBINDS_FILE"
echo "# additionalScripts keybinds — source this in hyprland.conf" >> "$KEYBINDS_FILE"
echo "" >> "$KEYBINDS_FILE"

for script_dir in "$DIR"/*/; do
    name=$(basename "$script_dir")
    setup_script="$script_dir/setup.sh"

    if [[ -f "$setup_script" ]]; then
        printf "[%s] Setting up...\n" "$name"
        bash "$setup_script" >> "$KEYBINDS_FILE"
        printf "[%s] Done\n" "$name"
        echo ""
    fi
done

echo "=== Done ==="
echo ""
echo "Add this line to your hyprland.conf:"
echo "  source = $KEYBINDS_FILE"

#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="bemenu-caelestia"

mkdir -p "$BIN_DIR"

ln -sf "$DIR/$SCRIPT_NAME.sh" "$BIN_DIR/$SCRIPT_NAME"

echo "bind = SUPER, D, exec, $SCRIPT_NAME-run"
#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="workspace-setup"

mkdir -p "$BIN_DIR"

ln -sf "$DIR/$SCRIPT_NAME.sh" "$BIN_DIR/$SCRIPT_NAME"

bash "$DIR/parser.sh"

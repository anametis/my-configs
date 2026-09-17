#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$CONFIG_DIR/settings.sh"

[[ -n "$SKETCHYBAR_BIN" ]] || exit 0
"$SKETCHYBAR_BIN" --set "${NAME:-system.time}" label="$(date '+%H:%M')"

#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$CONFIG_DIR/settings.sh"

if [[ -z "$SKETCHYBAR_BIN" ]]; then
  exit 0
fi

"$SKETCHYBAR_BIN" --trigger aerospace_workspace_change \
  FOCUSED_WORKSPACE="${1:-}" \
  PREV_WORKSPACE="${2:-}"

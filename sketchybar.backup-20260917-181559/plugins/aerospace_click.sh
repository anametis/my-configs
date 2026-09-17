#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$CONFIG_DIR/settings.sh"

workspace="${1:-}"
if [[ ! "$workspace" =~ ^[1-9]$ ]] || [[ -z "$AEROSPACE_BIN" ]]; then
  exit 1
fi

"$AEROSPACE_BIN" workspace "$workspace"

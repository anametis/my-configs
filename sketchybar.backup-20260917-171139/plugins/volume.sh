#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/settings.sh"
source "$CONFIG_DIR/icons.sh"

[[ -n "$SKETCHYBAR_BIN" ]] || exit 0

volume="${INFO:-}"
muted=false

if [[ ! "$volume" =~ ^[0-9]+$ ]]; then
  volume_state=$(
    /usr/bin/osascript \
      -e 'set volumeInfo to get volume settings' \
      -e 'return (output volume of volumeInfo as text) & "|" & (output muted of volumeInfo as text)' \
      2>/dev/null || true
  )
  IFS='|' read -r volume muted <<< "$volume_state"
fi

[[ "$volume" =~ ^[0-9]+$ ]] || volume=0

if [[ "$muted" == "true" ]] || (( volume == 0 )); then
  icon="$VOLUME_MUTED_ICON"
  color="$EMPTY_TEXT"
elif (( volume < 34 )); then
  icon="$VOLUME_LOW_ICON"
  color="$OCCUPIED_TEXT"
elif (( volume < 67 )); then
  icon="$VOLUME_MEDIUM_ICON"
  color="$VISIBLE_TEXT"
else
  icon="$VOLUME_HIGH_ICON"
  color="$FOCUSED_TEXT"
fi

"$SKETCHYBAR_BIN" --set "${NAME:-system.volume}" \
  icon="$icon" \
  icon.color="$color" \
  label="${volume}%"

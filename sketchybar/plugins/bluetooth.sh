#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/settings.sh"
source "$CONFIG_DIR/icons.sh"

[[ -n "$SKETCHYBAR_BIN" ]] || exit 0

blueutil_bin="$(resolve_command blueutil 2>/dev/null || true)"
power_state=""
connected=false

if [[ -n "$blueutil_bin" ]]; then
  power_state=$("$blueutil_bin" --power 2>/dev/null || true)
  if "$blueutil_bin" --paired --format json 2>/dev/null |
      /usr/bin/grep -q '"connected":[[:space:]]*true'; then
    connected=true
  fi
else
  power_state=$(/usr/bin/defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null || true)
fi

icon="$BLUETOOTH_OFF_ICON"
color="$EMPTY_TEXT"
if [[ "$power_state" == "1" ]]; then
  icon="$BLUETOOTH_ON_ICON"
  color="$OCCUPIED_TEXT"
  [[ "$connected" == "true" ]] && color="$FOCUSED_TEXT"
fi

"$SKETCHYBAR_BIN" --set "${NAME:-system.bluetooth}" icon="$icon" icon.color="$color"

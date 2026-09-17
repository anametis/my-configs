#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/settings.sh"
source "$CONFIG_DIR/icons.sh"

[[ -n "$SKETCHYBAR_BIN" ]] || exit 0

battery_state=$(/usr/bin/pmset -g batt 2>/dev/null || true)
percentage=$(printf '%s\n' "$battery_state" | /usr/bin/grep -Eo '[0-9]+%' | /usr/bin/head -n 1 | /usr/bin/tr -d '%')

if [[ ! "$percentage" =~ ^[0-9]+$ ]]; then
  "$SKETCHYBAR_BIN" --set "${NAME:-system.battery}" drawing=off
  exit 0
fi

color="$VISIBLE_TEXT"
if [[ "$battery_state" == *"; charging"* ]]; then
  icon="$BATTERY_CHARGING_ICON"
  color="$FOCUSED_TEXT"
elif (( percentage >= 90 )); then
  icon="$BATTERY_FULL_ICON"
elif (( percentage >= 65 )); then
  icon="$BATTERY_HIGH_ICON"
elif (( percentage >= 35 )); then
  icon="$BATTERY_MEDIUM_ICON"
elif (( percentage >= 15 )); then
  icon="$BATTERY_LOW_ICON"
  color="$WARNING_COLOR"
else
  icon="$BATTERY_EMPTY_ICON"
  color="$CRITICAL_COLOR"
fi

"$SKETCHYBAR_BIN" --set "${NAME:-system.battery}" \
  drawing=on \
  icon="$icon" \
  icon.color="$color" \
  label="${percentage}%"

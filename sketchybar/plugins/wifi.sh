#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/settings.sh"
source "$CONFIG_DIR/icons.sh"

[[ -n "$SKETCHYBAR_BIN" ]] || exit 0

wifi_device=$(
  /usr/sbin/networksetup -listallhardwareports 2>/dev/null |
    /usr/bin/awk '/Hardware Port: (Wi-Fi|AirPort)/ { getline; print $2; exit }'
)

icon="$WIFI_DISCONNECTED_ICON"
color="$EMPTY_TEXT"

if [[ -n "$wifi_device" ]]; then
  power_state=$(/usr/sbin/networksetup -getairportpower "$wifi_device" 2>/dev/null || true)
  network_state=$(/usr/sbin/networksetup -getairportnetwork "$wifi_device" 2>/dev/null || true)
  wifi_address=$(/usr/sbin/ipconfig getifaddr "$wifi_device" 2>/dev/null || true)
  interface_status=$(
    /sbin/ifconfig "$wifi_device" 2>/dev/null |
      /usr/bin/awk '/status:/ { print $2; exit }'
  )

  if [[ "$power_state" == *": On" ]]; then
    color="$OCCUPIED_TEXT"
    if [[ "$network_state" == "Current Wi-Fi Network:"* ]] ||
       { [[ -n "$wifi_address" ]] && [[ "$interface_status" == "active" ]]; }; then
      icon="$WIFI_CONNECTED_ICON"
      color="$FOCUSED_TEXT"
    fi
  fi
fi

"$SKETCHYBAR_BIN" --set "${NAME:-system.wifi}" icon="$icon" icon.color="$color"

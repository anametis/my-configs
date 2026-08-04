#!/usr/bin/env bash

status_item=(
  padding_left=0
  padding_right=0
  icon.font="$APP_ICON_FONT"
  icon.color="$OCCUPIED_TEXT"
  icon.padding_left=5
  icon.padding_right=4
  label.font="$STATUS_LABEL_FONT"
  label.color="$VISIBLE_TEXT"
  label.padding_left=0
  label.padding_right=5
  background.drawing=off
)

"$SKETCHYBAR_BIN" \
  --add item system.battery right \
  --set system.battery "${status_item[@]}" \
    icon="$BATTERY_HIGH_ICON" \
    icon.padding_left=6 \
    label.padding_right=8 \
    update_freq=60 \
    script="$CONFIG_DIR/plugins/battery.sh" \
  --subscribe system.battery system_status_refresh power_source_change system_woke \
  --add item system.volume right \
  --set system.volume "${status_item[@]}" \
    icon="$VOLUME_MEDIUM_ICON" \
    script="$CONFIG_DIR/plugins/volume.sh" \
  --subscribe system.volume system_status_refresh volume_change system_woke \
  --add item system.bluetooth right \
  --set system.bluetooth "${status_item[@]}" \
    icon="$BLUETOOTH_OFF_ICON" \
    label.drawing=off \
    update_freq=20 \
    script="$CONFIG_DIR/plugins/bluetooth.sh" \
  --subscribe system.bluetooth system_status_refresh system_woke \
  --add item system.wifi right \
  --set system.wifi "${status_item[@]}" \
    icon="$WIFI_DISCONNECTED_ICON" \
    label.drawing=off \
    update_freq=30 \
    script="$CONFIG_DIR/plugins/wifi.sh" \
  --subscribe system.wifi system_status_refresh wifi_change system_woke \
  --add item system.time right \
  --set system.time "${status_item[@]}" \
    icon="$CLOCK_ICON" \
    update_freq=10 \
    script="$CONFIG_DIR/plugins/time.sh" \
  --subscribe system.time system_status_refresh system_woke

"$SKETCHYBAR_BIN" \
  --add bracket system.status \
    system.time system.wifi system.bluetooth system.volume system.battery \
  --set system.status \
    background.drawing=on \
    background.color="$CAPSULE_BACKGROUND" \
    background.border_color="$CAPSULE_BORDER" \
    background.border_width=1 \
    background.height=30 \
    background.corner_radius="$CORNER_RADIUS"

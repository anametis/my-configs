#!/usr/bin/env bash

for workspace in {1..9}; do
  "$SKETCHYBAR_BIN" --add item "aerospace.space.$workspace" left \
    --set "aerospace.space.$workspace" \
      drawing=off \
      icon="$workspace" \
      label.drawing=off \
      click_script="'$CONFIG_DIR/plugins/aerospace_click.sh' '$workspace'"
done

"$SKETCHYBAR_BIN" \
  --add bracket aerospace.spaces.main \
    aerospace.space.1 aerospace.space.2 aerospace.space.3 aerospace.space.4 aerospace.space.5 \
  --set aerospace.spaces.main \
    drawing=off \
    background.drawing=on \
    background.color="$CAPSULE_BACKGROUND" \
    background.border_color="$CAPSULE_BORDER" \
    background.border_width=1 \
    background.height=30 \
    background.corner_radius="$CORNER_RADIUS" \
  --add bracket aerospace.spaces.secondary \
    aerospace.space.6 aerospace.space.7 aerospace.space.8 aerospace.space.9 \
  --set aerospace.spaces.secondary \
    drawing=off \
    background.drawing=on \
    background.color="$CAPSULE_BACKGROUND" \
    background.border_color="$CAPSULE_BORDER" \
    background.border_width=1 \
    background.height=30 \
    background.corner_radius="$CORNER_RADIUS"

"$SKETCHYBAR_BIN" --add item aerospace.watcher left \
  --set aerospace.watcher \
    drawing=off \
    updates=on \
    update_freq="$RECONCILE_SECONDS" \
    script="$CONFIG_DIR/plugins/aerospace_refresh.sh" \
  --subscribe aerospace.watcher \
    aerospace_workspace_change \
    aerospace_state_change \
    front_app_switched \
    space_change \
    display_change \
    system_woke

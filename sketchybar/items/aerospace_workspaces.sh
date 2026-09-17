#!/usr/bin/env bash

main_members=()
secondary_members=()

append_member() {
  local workspace="$1"
  local member="$2"
  if (( workspace <= 5 )); then
    main_members+=("$member")
  else
    secondary_members+=("$member")
  fi
}

for workspace in {1..9}; do
  space_name="aerospace.space.$workspace"

  "$SKETCHYBAR_BIN" --add item "$space_name" left \
    --set "$space_name" \
      drawing=off \
      padding_left="$WORKSPACE_ITEM_GAP" \
      padding_right=0 \
      icon="$workspace" \
      icon.font="$NUMBER_FONT" \
      icon.padding_left="$WORKSPACE_PADDING" \
      icon.padding_right="$WORKSPACE_PADDING" \
      label.drawing=off \
      label.font="$OVERFLOW_FONT" \
      label.padding_left=0 \
      label.padding_right=3 \
      background.height="$ITEM_HEIGHT" \
      background.corner_radius="$ACTIVE_CORNER_RADIUS" \
      click_script="'$CONFIG_DIR/plugins/aerospace_click.sh' '$workspace'"

  append_member "$workspace" "$space_name"

  # Pre-create a few image slots per workspace. Refreshes only swap the native
  # app image and visibility, avoiding add/remove churn while windows move.
  for ((slot=1; slot<=MAX_APP_ICONS; slot++)); do
    app_name="aerospace.app.$workspace.$slot"
    "$SKETCHYBAR_BIN" --add item "$app_name" left \
      --set "$app_name" \
        drawing=off \
        width="$APP_IMAGE_WIDTH" \
        padding_left=0 \
        padding_right=1 \
        icon.drawing=off \
        label.drawing=off \
        background.drawing=on \
        background.color="$TRANSPARENT" \
        background.height="$APP_IMAGE_HEIGHT" \
        background.corner_radius="$APP_IMAGE_CORNER_RADIUS" \
        background.image.drawing=on \
        background.image.scale="$APP_IMAGE_SCALE" \
        background.image.corner_radius="$APP_IMAGE_CORNER_RADIUS" \
        click_script="'$CONFIG_DIR/plugins/aerospace_click.sh' '$workspace'"

    append_member "$workspace" "$app_name"
  done
done

"$SKETCHYBAR_BIN" \
  --add bracket aerospace.spaces.main "${main_members[@]}" \
  --set aerospace.spaces.main \
    drawing=off \
    background.drawing=on \
    background.color="$CAPSULE_BACKGROUND" \
    background.border_color="$CAPSULE_BORDER" \
    background.border_width=1 \
    background.height=30 \
    background.corner_radius="$CORNER_RADIUS" \
    background.padding_left="$CAPSULE_EDGE_PADDING" \
    background.padding_right="$CAPSULE_EDGE_PADDING" \
  --add bracket aerospace.spaces.secondary "${secondary_members[@]}" \
  --set aerospace.spaces.secondary \
    drawing=off \
    background.drawing=on \
    background.color="$CAPSULE_BACKGROUND" \
    background.border_color="$CAPSULE_BORDER" \
    background.border_width=1 \
    background.height=30 \
    background.corner_radius="$CORNER_RADIUS" \
    background.padding_left="$CAPSULE_EDGE_PADDING" \
    background.padding_right="$CAPSULE_EDGE_PADDING"

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

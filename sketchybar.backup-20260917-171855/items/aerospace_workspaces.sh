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
  workspace_members=("$space_name")

  "$SKETCHYBAR_BIN" --add item "$space_name" left \
    --set "$space_name" \
      drawing=off \
      padding_left=0 \
      padding_right=0 \
      icon="$workspace" \
      icon.font="$EMPTY_NUMBER_FONT" \
      icon.padding_left="$WORKSPACE_EMPTY_PADDING" \
      icon.padding_right="$WORKSPACE_EMPTY_PADDING" \
      icon.y_offset=0 \
      label.drawing=off \
      label.font="$OVERFLOW_FONT" \
      label.padding_left=0 \
      label.padding_right=3 \
      label.y_offset=0 \
      background.height="$ITEM_HEIGHT" \
      background.corner_radius="$ACTIVE_CORNER_RADIUS" \
      click_script="'$CONFIG_DIR/plugins/aerospace_click.sh' '$workspace'"

  append_member "$workspace" "$space_name"

  # Each app slot remains a native SketchyBar app image. The slots themselves
  # are intentionally narrow; the workspace-level bracket below creates the
  # visual group around the number + icons.
  for ((slot=1; slot<=MAX_APP_ICONS; slot++)); do
    app_name="aerospace.app.$workspace.$slot"
    "$SKETCHYBAR_BIN" --add item "$app_name" left \
      --set "$app_name" \
        drawing=off \
        width="$APP_IMAGE_WIDTH" \
        padding_left="$APP_IMAGE_PADDING" \
        padding_right="$APP_IMAGE_PADDING" \
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

    workspace_members+=("$app_name")
    append_member "$workspace" "$app_name"
  done

  # Occupied workspaces become one visual unit: number + app icons. The bracket
  # is hidden for empty workspaces, leaving only a narrow number-only target.
  group_name="aerospace.group.$workspace"
  "$SKETCHYBAR_BIN" --add bracket "$group_name" "${workspace_members[@]}" \
    --set "$group_name" \
      drawing=off \
      background.drawing=on \
      background.color="$TRANSPARENT" \
      background.border_color="$CAPSULE_BORDER" \
      background.border_width=1 \
      background.height="$ITEM_HEIGHT" \
      background.corner_radius="$ACTIVE_CORNER_RADIUS" \
      background.padding_left="$WORKSPACE_GROUP_EDGE_PADDING" \
      background.padding_right="$WORKSPACE_GROUP_EDGE_PADDING"

  # A larger invisible gap separates workspace groups. This is deliberately
  # wider than the icon-to-icon spacing inside an occupied group.
  if (( workspace != 5 && workspace != 9 )); then
    gap_name="aerospace.gap.$workspace"
    "$SKETCHYBAR_BIN" --add item "$gap_name" left \
      --set "$gap_name" \
        drawing=off \
        width="$WORKSPACE_GROUP_GAP" \
        padding_left=0 \
        padding_right=0 \
        icon.drawing=off \
        label.drawing=off \
        background.drawing=off
    append_member "$workspace" "$gap_name"
  fi
done

"$SKETCHYBAR_BIN" \
  --add bracket aerospace.spaces.main "${main_members[@]}" \
  --set aerospace.spaces.main \
    drawing=off \
    background.drawing=on \
    background.color="$CAPSULE_BACKGROUND" \
    background.border_color="$CAPSULE_BORDER" \
    background.border_width=1 \
    background.height="$CAPSULE_HEIGHT" \
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
    background.height="$CAPSULE_HEIGHT" \
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

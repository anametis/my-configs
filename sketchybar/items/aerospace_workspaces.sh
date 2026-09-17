#!/usr/bin/env bash

# One window owns the entire capsule, including its click target. No workspace
# brackets or separate app windows can obscure or intercept its contents.
for workspace in {1..9}; do
  gap="$((WORKSPACE_GROUP_GAP - 2 * WORKSPACE_GROUP_EDGE_PADDING))"
  [[ "$workspace" == 5 || "$workspace" == 9 ]] && gap=0
  "$SKETCHYBAR_BIN" --add item "aerospace.space.$workspace" left \
    --set "aerospace.space.$workspace" \
      drawing=off \
      padding_left=0 padding_right="$gap" \
      icon="$workspace" icon.font="$EMPTY_NUMBER_FONT" \
      icon.padding_left="$WORKSPACE_NUMBER_PADDING" \
      icon.padding_right="$WORKSPACE_NUMBER_PADDING" \
      label.drawing=off label.font="$OVERFLOW_FONT" \
      label.padding_left=0 label.padding_right=3 \
      label.background.image.scale=0.5 \
      label.background.drawing=on label.background.color="$TRANSPARENT" \
      background.drawing=on background.color="$WORKSPACE_BACKGROUND" \
      background.border_color="$WORKSPACE_BORDER" background.border_width=1 \
      background.height="$ITEM_HEIGHT" \
      background.corner_radius="$WORKSPACE_CORNER_RADIUS" \
      click_script="'$CONFIG_DIR/plugins/aerospace_click.sh' '$workspace'"
done

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

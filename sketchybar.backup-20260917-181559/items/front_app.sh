#!/usr/bin/env bash

# Keep the separator outside the bracket so the current-app capsule is a clean,
# independent component rather than visually connecting to the workspace rail.
"$SKETCHYBAR_BIN" --add item aerospace.front_app.gap left \
  --set aerospace.front_app.gap \
    drawing=off \
    width="$FRONT_APP_OUTER_GAP" \
    padding_left=0 \
    padding_right=0 \
    icon.drawing=off \
    label.drawing=off \
    background.drawing=off

"$SKETCHYBAR_BIN" --add item aerospace.front_app.icon left \
  --set aerospace.front_app.icon \
    drawing=off \
    width="$FRONT_APP_IMAGE_WIDTH" \
    padding_left=0 \
    padding_right=0 \
    icon.drawing=off \
    label.drawing=off \
    background.drawing=on \
    background.color="$TRANSPARENT" \
    background.height="$FRONT_APP_IMAGE_HEIGHT" \
    background.corner_radius="$FRONT_APP_IMAGE_CORNER_RADIUS" \
    background.image.drawing=on \
    background.image.scale="$FRONT_APP_IMAGE_SCALE" \
    background.image.corner_radius="$FRONT_APP_IMAGE_CORNER_RADIUS"

"$SKETCHYBAR_BIN" --add item aerospace.front_app.label left \
  --set aerospace.front_app.label \
    drawing=off \
    padding_left="$FRONT_APP_ICON_TEXT_GAP" \
    padding_right=0 \
    icon.drawing=off \
    label.font="$FRONT_APP_FONT" \
    label.color="$VISIBLE_TEXT" \
    label.max_chars="$FRONT_APP_MAX_LENGTH" \
    label.padding_left=0 \
    label.padding_right=0 \
    label.y_offset=0 \
    background.drawing=off

"$SKETCHYBAR_BIN" --add bracket aerospace.front_app \
  aerospace.front_app.icon aerospace.front_app.label \
  --set aerospace.front_app \
    drawing=off \
    background.drawing=on \
    background.color="$FRONT_APP_BACKGROUND" \
    background.border_color="$FRONT_APP_BORDER" \
    background.border_width=1 \
    background.height="$CAPSULE_HEIGHT" \
    background.corner_radius="$CORNER_RADIUS" \
    background.padding_left="$FRONT_APP_INNER_PADDING" \
    background.padding_right="$FRONT_APP_INNER_PADDING"

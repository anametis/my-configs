#!/usr/bin/env bash

"$SKETCHYBAR_BIN" --add item aerospace.front_app.gap left \
  --set aerospace.front_app.gap \
    drawing=off \
    width="$FRONT_APP_OUTER_GAP" \
    padding_left=0 \
    padding_right=0 \
    icon.drawing=off \
    label.drawing=off \
    background.drawing=off

# Use item padding for real content spacing. Bracket background padding only
# changes the background geometry and was the reason this area felt cramped.
"$SKETCHYBAR_BIN" --add item aerospace.front_app.icon left \
  --set aerospace.front_app.icon \
    drawing=off \
    width="$FRONT_APP_IMAGE_WIDTH" \
    padding_left="$FRONT_APP_ICON_LEFT_PADDING" \
    padding_right="$FRONT_APP_ICON_RIGHT_PADDING" \
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
    padding_left="$FRONT_APP_LABEL_LEFT_PADDING" \
    padding_right="$FRONT_APP_LABEL_RIGHT_PADDING" \
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
    background.padding_left=0 \
    background.padding_right=0 \
    background.shadow.drawing=on \
    background.shadow.color=0x55000000 \
    background.shadow.distance=1

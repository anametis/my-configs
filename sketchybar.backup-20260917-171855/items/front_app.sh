#!/usr/bin/env bash

"$SKETCHYBAR_BIN" --add item aerospace.front_app left \
  --set aerospace.front_app \
    drawing=off \
    padding_left="$FRONT_APP_OUTER_GAP" \
    padding_right=0 \
    icon="" \
    icon.drawing=on \
    icon.width="$FRONT_APP_IMAGE_WIDTH" \
    icon.padding_left=9 \
    icon.padding_right="$FRONT_APP_ICON_TEXT_GAP" \
    icon.y_offset=0 \
    icon.background.drawing=on \
    icon.background.color="$TRANSPARENT" \
    icon.background.height="$FRONT_APP_IMAGE_HEIGHT" \
    icon.background.corner_radius="$FRONT_APP_IMAGE_CORNER_RADIUS" \
    icon.background.image.drawing=on \
    icon.background.image.scale="$FRONT_APP_IMAGE_SCALE" \
    icon.background.image.corner_radius="$FRONT_APP_IMAGE_CORNER_RADIUS" \
    label.font="$FRONT_APP_FONT" \
    label.color="$VISIBLE_TEXT" \
    label.max_chars="$FRONT_APP_MAX_LENGTH" \
    label.padding_left=0 \
    label.padding_right=13 \
    label.y_offset=0 \
    background.drawing=on \
    background.color="$CAPSULE_BACKGROUND" \
    background.border_color="$CAPSULE_BORDER" \
    background.border_width=1 \
    background.height="$CAPSULE_HEIGHT" \
    background.corner_radius="$CORNER_RADIUS"

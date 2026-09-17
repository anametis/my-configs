#!/usr/bin/env bash

"$SKETCHYBAR_BIN" --add item aerospace.front_app left \
  --set aerospace.front_app \
    drawing=off \
    padding_left=7 \
    icon="" \
    icon.drawing=on \
    icon.width="$FRONT_APP_IMAGE_WIDTH" \
    icon.padding_left=8 \
    icon.padding_right=5 \
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
    label.padding_right=10 \
    background.drawing=on \
    background.color="$CAPSULE_BACKGROUND" \
    background.border_color="$CAPSULE_BORDER" \
    background.border_width=1 \
    background.height=30 \
    background.corner_radius="$CORNER_RADIUS"

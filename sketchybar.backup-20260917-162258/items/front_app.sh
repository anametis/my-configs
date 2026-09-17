#!/usr/bin/env bash

"$SKETCHYBAR_BIN" --add item aerospace.front_app left \
  --set aerospace.front_app \
    drawing=off \
    padding_left=7 \
    icon="$CHEVRON_BACK" \
    icon.font="SF Pro:Regular:25.0" \
    icon.color="$EMPTY_TEXT" \
    icon.padding_left=8 \
    icon.padding_right=7 \
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

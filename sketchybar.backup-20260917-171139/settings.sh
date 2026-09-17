#!/usr/bin/env bash

# Keep the original compact layout, but give native app artwork a little more
# breathing room. The main visual change is less crowding, not a redesign.
export BAR_HEIGHT=32
export ITEM_HEIGHT=22
export CAPSULE_HEIGHT=28
export CORNER_RADIUS=9
export ACTIVE_CORNER_RADIUS=7
export WORKSPACE_PADDING=6
export WORKSPACE_ITEM_GAP=0
export WORKSPACE_GROUP_GAP=7
export CAPSULE_EDGE_PADDING=7
export ICON_GAP=5
export FRONT_APP_OUTER_GAP=11
export FRONT_APP_ICON_TEXT_GAP=8

# Native macOS application artwork. Native app icons are visually heavier than
# font glyphs, so render them smaller and add explicit slot padding.
export APP_IMAGE_WIDTH=16
export APP_IMAGE_HEIGHT=16
export APP_IMAGE_SCALE=0.56
export APP_IMAGE_CORNER_RADIUS=4
export APP_IMAGE_PADDING=3

export FRONT_APP_IMAGE_WIDTH=16
export FRONT_APP_IMAGE_HEIGHT=16
export FRONT_APP_IMAGE_SCALE=0.56
export FRONT_APP_IMAGE_CORNER_RADIUS=4

# Showing the same full-color app icon once per window gets noisy very quickly.
# Default to one icon per application; set SHOW_DUPLICATE_WINDOWS=true if you
# specifically want a separate icon for every window.
export SHOW_DUPLICATE_WINDOWS="${SHOW_DUPLICATE_WINDOWS:-false}"
export MAX_APP_ICONS="${MAX_APP_ICONS:-4}"
export RECONCILE_SECONDS="${RECONCILE_SECONDS:-4}"
export FRONT_APP_MAX_LENGTH="${FRONT_APP_MAX_LENGTH:-22}"

export NUMBER_FONT="SF Pro:Semibold:14.0"
export OVERFLOW_FONT="SF Pro:Medium:9.5"
export FALLBACK_APP_ICON_FONT="Symbols Nerd Font:Regular:13.0"
export SYSTEM_ICON_FONT="Symbols Nerd Font:Regular:13.0"
export FRONT_APP_FONT="SF Pro:Medium:13.5"
export STATUS_LABEL_FONT="SF Pro:Medium:12.5"

# Backwards-compatible alias for the small number of existing scripts that may
# still refer to APP_ICON_FONT.
export APP_ICON_FONT="$SYSTEM_ICON_FONT"

resolve_command() {
  local command_name="$1"
  local candidate

  if command -v "$command_name" >/dev/null 2>&1; then
    command -v "$command_name"
    return 0
  fi

  for candidate in "/opt/homebrew/bin/$command_name" "/usr/local/bin/$command_name"; do
    if [[ -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

export SKETCHYBAR_BIN="${SKETCHYBAR_BIN:-$(resolve_command sketchybar 2>/dev/null || true)}"
export AEROSPACE_BIN="${AEROSPACE_BIN:-$(resolve_command aerospace 2>/dev/null || true)}"

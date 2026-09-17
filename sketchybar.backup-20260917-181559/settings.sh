#!/usr/bin/env bash

# Reference-style grouped workspace layout.
# Empty workspaces stay as simple numbers in the shared rail. Occupied
# workspaces get a clearly visible inner capsule around number + app icons.
export BAR_HEIGHT=42
export ITEM_HEIGHT=30
export CAPSULE_HEIGHT=35
export CORNER_RADIUS=12
export ACTIVE_CORNER_RADIUS=9

# Spacing hierarchy: close within a group, relaxed between groups/capsules.
export WORKSPACE_EMPTY_PADDING=10
export WORKSPACE_OCCUPIED_PADDING=7
export EMPTY_WORKSPACE_GAP=5
export WORKSPACE_GROUP_GAP=9
export WORKSPACE_GROUP_EDGE_PADDING=4
export CAPSULE_EDGE_PADDING=10
export FRONT_APP_OUTER_GAP=16
export FRONT_APP_INNER_PADDING=10
export FRONT_APP_ICON_TEXT_GAP=7

# Compatibility values used by defaults/status items.
export WORKSPACE_PADDING="$WORKSPACE_EMPTY_PADDING"
export WORKSPACE_ITEM_GAP=0

# Native macOS application artwork.
export APP_IMAGE_WIDTH=24
export APP_IMAGE_HEIGHT=23
export APP_IMAGE_SCALE=0.70
export APP_IMAGE_CORNER_RADIUS=6
export APP_IMAGE_PADDING=3

export FRONT_APP_IMAGE_WIDTH=25
export FRONT_APP_IMAGE_HEIGHT=24
export FRONT_APP_IMAGE_SCALE=0.71
export FRONT_APP_IMAGE_CORNER_RADIUS=6

# One icon per application keeps groups compact even with many windows.
export SHOW_DUPLICATE_WINDOWS="${SHOW_DUPLICATE_WINDOWS:-false}"
export MAX_APP_ICONS="${MAX_APP_ICONS:-4}"
export RECONCILE_SECONDS="${RECONCILE_SECONDS:-4}"
export FRONT_APP_MAX_LENGTH="${FRONT_APP_MAX_LENGTH:-22}"

export NUMBER_FONT="SF Pro:Semibold:15.0"
export EMPTY_NUMBER_FONT="SF Pro:Medium:15.0"
export OVERFLOW_FONT="SF Pro:Semibold:10.5"
export FALLBACK_APP_ICON_FONT="Symbols Nerd Font:Regular:13.5"
export SYSTEM_ICON_FONT="Symbols Nerd Font:Regular:14.0"
export FRONT_APP_FONT="SF Pro:Semibold:16.0"
export STATUS_LABEL_FONT="SF Pro:Medium:13.0"

# Backwards-compatible alias.
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

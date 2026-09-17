#!/usr/bin/env bash

# Reference-style grouped workspaces.
# The goal is stronger visual hierarchy rather than simply adding more space:
#   outer capsule > workspace tile/group > native app artwork.
export BAR_HEIGHT=38
export ITEM_HEIGHT=28
export CAPSULE_HEIGHT=34
export CORNER_RADIUS=11
export ACTIVE_CORNER_RADIUS=8

# Workspace spacing. Empty workspaces are compact tiles; occupied workspaces
# have enough room for number + icons but stay visually grouped.
export WORKSPACE_EMPTY_PADDING=7
export WORKSPACE_OCCUPIED_PADDING=6
export EMPTY_WORKSPACE_GAP=3
export WORKSPACE_GROUP_GAP=6
export WORKSPACE_GROUP_EDGE_PADDING=4
export CAPSULE_EDGE_PADDING=6
export FRONT_APP_OUTER_GAP=16
export FRONT_APP_ICON_TEXT_GAP=7

# Compatibility values used by existing defaults/status items.
export WORKSPACE_PADDING="$WORKSPACE_EMPTY_PADDING"
export WORKSPACE_ITEM_GAP=0

# Native macOS application artwork. Larger than the previous trial so app
# identity is visible at a glance, but still leaves padding inside each group.
export APP_IMAGE_WIDTH=21
export APP_IMAGE_HEIGHT=21
export APP_IMAGE_SCALE=0.70
export APP_IMAGE_CORNER_RADIUS=5
export APP_IMAGE_PADDING=2

export FRONT_APP_IMAGE_WIDTH=22
export FRONT_APP_IMAGE_HEIGHT=22
export FRONT_APP_IMAGE_SCALE=0.72
export FRONT_APP_IMAGE_CORNER_RADIUS=6

# One icon per application by default; multiple windows of the same app should
# not make a workspace balloon horizontally.
export SHOW_DUPLICATE_WINDOWS="${SHOW_DUPLICATE_WINDOWS:-false}"
export MAX_APP_ICONS="${MAX_APP_ICONS:-4}"
export RECONCILE_SECONDS="${RECONCILE_SECONDS:-4}"
export FRONT_APP_MAX_LENGTH="${FRONT_APP_MAX_LENGTH:-22}"

export NUMBER_FONT="SF Pro:Semibold:14.0"
export EMPTY_NUMBER_FONT="SF Pro:Medium:13.5"
export OVERFLOW_FONT="SF Pro:Semibold:10.0"
export FALLBACK_APP_ICON_FONT="Symbols Nerd Font:Regular:13.0"
export SYSTEM_ICON_FONT="Symbols Nerd Font:Regular:13.5"
export FRONT_APP_FONT="SF Pro:Semibold:14.0"
export STATUS_LABEL_FONT="SF Pro:Medium:12.5"

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

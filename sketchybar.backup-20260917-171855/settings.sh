#!/usr/bin/env bash

# Grouped workspace trial: occupied workspaces read as small self-contained
# groups, while empty workspaces stay narrow and quiet. Keep the existing bar
# size, palette, and native macOS app artwork.
export BAR_HEIGHT=32
export ITEM_HEIGHT=22
export CAPSULE_HEIGHT=28
export CORNER_RADIUS=9
export ACTIVE_CORNER_RADIUS=7

# Workspace spacing hierarchy.
export WORKSPACE_EMPTY_PADDING=4
export WORKSPACE_OCCUPIED_PADDING=4
export EMPTY_WORKSPACE_GAP=3
export WORKSPACE_GROUP_GAP=9
export WORKSPACE_GROUP_EDGE_PADDING=3
export CAPSULE_EDGE_PADDING=8
export FRONT_APP_OUTER_GAP=15
export FRONT_APP_ICON_TEXT_GAP=8

# Compatibility values used by the existing global defaults/status items.
export WORKSPACE_PADDING="$WORKSPACE_EMPTY_PADDING"
export WORKSPACE_ITEM_GAP=0

# Native macOS application artwork. Keep icons readable, but let the workspace
# group itself provide the visual breathing room rather than oversized slots.
export APP_IMAGE_WIDTH=16
export APP_IMAGE_HEIGHT=16
export APP_IMAGE_SCALE=0.55
export APP_IMAGE_CORNER_RADIUS=4
export APP_IMAGE_PADDING=2

export FRONT_APP_IMAGE_WIDTH=16
export FRONT_APP_IMAGE_HEIGHT=16
export FRONT_APP_IMAGE_SCALE=0.55
export FRONT_APP_IMAGE_CORNER_RADIUS=4

# One icon per application by default; multiple windows of Chrome, Finder, etc.
# should not make a workspace group balloon unnecessarily.
export SHOW_DUPLICATE_WINDOWS="${SHOW_DUPLICATE_WINDOWS:-false}"
export MAX_APP_ICONS="${MAX_APP_ICONS:-4}"
export RECONCILE_SECONDS="${RECONCILE_SECONDS:-4}"
export FRONT_APP_MAX_LENGTH="${FRONT_APP_MAX_LENGTH:-22}"

export NUMBER_FONT="SF Pro:Semibold:13.0"
export EMPTY_NUMBER_FONT="SF Pro:Medium:12.5"
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

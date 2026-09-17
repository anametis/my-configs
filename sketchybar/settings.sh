#!/usr/bin/env bash

# Workspace layout: every workspace is a visible capsule. Empty workspaces are
# number-only; occupied workspaces naturally expand to include their app icons.
export BAR_HEIGHT=40
export ITEM_HEIGHT=30
export CAPSULE_HEIGHT=34
export CORNER_RADIUS=11
export WORKSPACE_CORNER_RADIUS=9

# Spacing: related content stays close, separate groups get breathing room.
export WORKSPACE_NUMBER_PADDING=9
export WORKSPACE_GROUP_EDGE_PADDING=2
export WORKSPACE_GROUP_GAP=5
export CAPSULE_EDGE_PADDING=5
export FRONT_APP_OUTER_GAP=13
export FRONT_APP_ICON_LEFT_PADDING=10
export FRONT_APP_ICON_RIGHT_PADDING=4
export FRONT_APP_LABEL_LEFT_PADDING=5
export FRONT_APP_LABEL_RIGHT_PADDING=12

# Compatibility values used by defaults/status items.
export WORKSPACE_PADDING="$WORKSPACE_NUMBER_PADDING"
export WORKSPACE_ITEM_GAP=1

# Native macOS application artwork.
export APP_IMAGE_WIDTH=22
export APP_IMAGE_HEIGHT=22
export APP_IMAGE_SCALE=0.64
export APP_IMAGE_CORNER_RADIUS=6
export APP_IMAGE_PADDING=3

export FRONT_APP_IMAGE_WIDTH=22
export FRONT_APP_IMAGE_HEIGHT=22
export FRONT_APP_IMAGE_SCALE=0.62
export FRONT_APP_IMAGE_CORNER_RADIUS=6

# One icon per application keeps a workspace readable with many windows.
export SHOW_DUPLICATE_WINDOWS="${SHOW_DUPLICATE_WINDOWS:-false}"
export MAX_APP_ICONS="${MAX_APP_ICONS:-4}"
export RECONCILE_SECONDS="${RECONCILE_SECONDS:-4}"
export FRONT_APP_MAX_LENGTH="${FRONT_APP_MAX_LENGTH:-22}"

export NUMBER_FONT="SF Pro:Semibold:15.5"
export EMPTY_NUMBER_FONT="SF Pro:Medium:15.5"
export OVERFLOW_FONT="SF Pro:Semibold:10.5"
export FALLBACK_APP_ICON_FONT="Symbols Nerd Font:Regular:13.5"
export SYSTEM_ICON_FONT="Symbols Nerd Font:Regular:14.0"
export FRONT_APP_FONT="SF Pro:Semibold:16.0"
export STATUS_LABEL_FONT="SF Pro:Medium:13.0"

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

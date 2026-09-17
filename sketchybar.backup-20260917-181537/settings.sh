#!/usr/bin/env bash

# Polished grouped workspace layout.
# Empty workspaces remain simple numbers; occupied workspaces become one
# clearly visible number + native-app-icon component.
export BAR_HEIGHT=40
export ITEM_HEIGHT=30
export CAPSULE_HEIGHT=34
export CORNER_RADIUS=11
export ACTIVE_CORNER_RADIUS=9

# Workspace rhythm: tight inside a workspace, clearer between workspaces.
export WORKSPACE_EMPTY_PADDING=8
export WORKSPACE_OCCUPIED_PADDING=6
export EMPTY_WORKSPACE_GAP=3
export WORKSPACE_GROUP_GAP=6
export WORKSPACE_GROUP_EDGE_PADDING=4
export CAPSULE_EDGE_PADDING=7
export FRONT_APP_OUTER_GAP=14
export FRONT_APP_INNER_PADDING=6
export FRONT_APP_ICON_TEXT_GAP=5

# Compatibility values used by defaults/status items.
export WORKSPACE_PADDING="$WORKSPACE_EMPTY_PADDING"
export WORKSPACE_ITEM_GAP=0

# Native macOS application artwork.
export APP_IMAGE_WIDTH=22
export APP_IMAGE_HEIGHT=22
export APP_IMAGE_SCALE=0.70
export APP_IMAGE_CORNER_RADIUS=6
export APP_IMAGE_PADDING=2

export FRONT_APP_IMAGE_WIDTH=25
export FRONT_APP_IMAGE_HEIGHT=23
export FRONT_APP_IMAGE_SCALE=0.70
export FRONT_APP_IMAGE_CORNER_RADIUS=6

# One icon per application keeps groups compact even with many windows.
export SHOW_DUPLICATE_WINDOWS="${SHOW_DUPLICATE_WINDOWS:-false}"
export MAX_APP_ICONS="${MAX_APP_ICONS:-4}"
export RECONCILE_SECONDS="${RECONCILE_SECONDS:-4}"
export FRONT_APP_MAX_LENGTH="${FRONT_APP_MAX_LENGTH:-22}"

export NUMBER_FONT="SF Pro:Semibold:14.0"
export EMPTY_NUMBER_FONT="SF Pro:Medium:14.0"
export OVERFLOW_FONT="SF Pro:Semibold:10.0"
export FALLBACK_APP_ICON_FONT="Symbols Nerd Font:Regular:13.0"
export SYSTEM_ICON_FONT="Symbols Nerd Font:Regular:13.5"
export FRONT_APP_FONT="SF Pro:Semibold:15.0"
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

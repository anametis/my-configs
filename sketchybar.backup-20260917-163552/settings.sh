#!/usr/bin/env bash

export BAR_HEIGHT=32
export ITEM_HEIGHT=26
export CORNER_RADIUS=5
export ACTIVE_CORNER_RADIUS=4
export WORKSPACE_PADDING=6
export WORKSPACE_ITEM_GAP=2
export CAPSULE_EDGE_PADDING=5
export ICON_GAP=4

export SHOW_DUPLICATE_WINDOWS="${SHOW_DUPLICATE_WINDOWS:-true}"
export MAX_APP_ICONS="${MAX_APP_ICONS:-4}"
export RECONCILE_SECONDS="${RECONCILE_SECONDS:-4}"
export FRONT_APP_MAX_LENGTH="${FRONT_APP_MAX_LENGTH:-22}"

export NUMBER_FONT="SF Pro:Semibold:15.0"
export APP_ICON_FONT="Symbols Nerd Font:Regular:14.0"
export FRONT_APP_FONT="SF Pro:Medium:14.0"
export STATUS_LABEL_FONT="SF Pro:Medium:13.0"

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

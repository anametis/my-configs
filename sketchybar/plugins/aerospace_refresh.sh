#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export CONFIG_DIR

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/settings.sh"
source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/helpers/app_icon.sh"

runtime_prefix="${TMPDIR:-/tmp}/sketchybar-aerospace-${UID}"
lock_dir="${runtime_prefix}.lock"
hash_file="${runtime_prefix}.hash"
error_file="${runtime_prefix}.error"

report_error_once() {
  local message="$1"
  local previous=""
  [[ -r "$error_file" ]] && IFS= read -r previous < "$error_file"
  if [[ "$previous" != "$message" ]]; then
    printf '%s\n' "$message" >&2
    printf '%s\n' "$message" > "$error_file"
  fi
}

if ! mkdir "$lock_dir" 2>/dev/null; then
  exit 0
fi
trap 'rmdir "$lock_dir" 2>/dev/null || true' EXIT

if [[ -z "$SKETCHYBAR_BIN" ]] || [[ -z "$AEROSPACE_BIN" ]]; then
  report_error_once "SketchyBar: AeroSpace or SketchyBar executable not found"
  exit 0
fi

separator=$'\x1f'
workspace_format="%{workspace}${separator}%{workspace-is-focused}${separator}%{workspace-is-visible}${separator}%{monitor-appkit-nsscreen-screens-id}"
window_format="%{workspace}${separator}%{window-id}${separator}%{app-name}${separator}%{app-bundle-id}"
front_format="%{workspace}${separator}%{app-name}${separator}%{app-bundle-id}${separator}%{monitor-appkit-nsscreen-screens-id}"

if ! workspace_state=$("$AEROSPACE_BIN" list-workspaces --all --format "$workspace_format" 2>/dev/null); then
  report_error_once "SketchyBar: unable to query AeroSpace workspaces; waiting for AeroSpace"
  exit 0
fi
if ! window_state=$("$AEROSPACE_BIN" list-windows --all --format "$window_format" 2>/dev/null); then
  report_error_once "SketchyBar: unable to query AeroSpace windows"
  exit 0
fi
front_state=$("$AEROSPACE_BIN" list-windows --focused --format "$front_format" 2>/dev/null || true)
rm -f "$error_file"

state_hash=$(
  printf '%s\n--windows--\n%s\n--front--\n%s\n' \
    "$workspace_state" "$window_state" "$front_state" | /usr/bin/shasum -a 256 | /usr/bin/awk '{print $1}'
)
previous_hash=""
[[ -r "$hash_file" ]] && IFS= read -r previous_hash < "$hash_file"

if [[ "${1:-}" != "--force" ]] && [[ "$state_hash" == "$previous_hash" ]]; then
  exit 0
fi

for workspace in {1..9}; do
  printf -v "icons_$workspace" '%s' ""
  printf -v "count_$workspace" '%s' "0"
  printf -v "seen_$workspace" '%s' "$separator"
  printf -v "focused_$workspace" '%s' "false"
  printf -v "visible_$workspace" '%s' "false"
  printf -v "display_$workspace" '%s' ""
done

while IFS="$separator" read -r workspace focused visible display_id; do
  [[ "$workspace" =~ ^[1-9]$ ]] || continue
  printf -v "focused_$workspace" '%s' "$focused"
  printf -v "visible_$workspace" '%s' "$visible"
  printf -v "display_$workspace" '%s' "$display_id"
done <<< "$workspace_state"

while IFS="$separator" read -r workspace window_id application_name bundle_id; do
  [[ "$workspace" =~ ^[1-9]$ ]] || continue

  key="${bundle_id:-$application_name}"
  seen_variable="seen_$workspace"
  seen_value="${!seen_variable}"
  if [[ "$SHOW_DUPLICATE_WINDOWS" != "true" ]] && [[ "$seen_value" == *"${separator}${key}${separator}"* ]]; then
    continue
  fi
  printf -v "$seen_variable" '%s' "${seen_value}${key}${separator}"

  count_variable="count_$workspace"
  count_value="${!count_variable}"
  count_value=$((count_value + 1))
  printf -v "$count_variable" '%s' "$count_value"

  if (( count_value <= MAX_APP_ICONS )); then
    icon="$(app_icon "$bundle_id" "$application_name")"
    icons_variable="icons_$workspace"
    icons_value="${!icons_variable}"
    if [[ -n "$icons_value" ]]; then
      icons_value+=" $icon"
    else
      icons_value="$icon"
    fi
    printf -v "$icons_variable" '%s' "$icons_value"
  fi
done <<< "$window_state"

arguments=()
main_display="${display_1:-}"
secondary_display="${display_6:-}"

for workspace in {1..9}; do
  name="aerospace.space.$workspace"
  icons_variable="icons_$workspace"
  count_variable="count_$workspace"
  focused_variable="focused_$workspace"
  visible_variable="visible_$workspace"
  display_variable="display_$workspace"
  icons_value="${!icons_variable}"
  count_value="${!count_variable}"
  focused_value="${!focused_variable}"
  visible_value="${!visible_variable}"
  display_value="${!display_variable}"

  [[ -n "$display_value" ]] || continue

  if (( count_value > MAX_APP_ICONS )); then
    icons_value+=" $OVERFLOW_ICON"
  fi

  text_color="$EMPTY_TEXT"
  background_color="$TRANSPARENT"
  border_color="$TRANSPARENT"
  border_width=0

  if [[ "$focused_value" == "true" ]]; then
    text_color="$FOCUSED_TEXT"
    background_color="$ACTIVE_BACKGROUND"
    border_color="$ACTIVE_BORDER"
    border_width=1
  elif [[ "$visible_value" == "true" ]]; then
    text_color="$VISIBLE_TEXT"
    border_color="$CAPSULE_BORDER"
    border_width=1
  elif (( count_value > 0 )); then
    text_color="$OCCUPIED_TEXT"
  fi

  label_drawing=off
  [[ -n "$icons_value" ]] && label_drawing=on

  arguments+=(
    --set "$name"
      drawing=on
      "display=$display_value"
      "label=$icons_value"
      "label.drawing=$label_drawing"
      "icon.color=$text_color"
      "label.color=$text_color"
      "background.color=$background_color"
      "background.border_color=$border_color"
      "background.border_width=$border_width"
  )
done

if [[ -n "$main_display" ]]; then
  arguments+=(--set aerospace.spaces.main drawing=on "display=$main_display")
fi
if [[ -n "$secondary_display" ]]; then
  arguments+=(--set aerospace.spaces.secondary drawing=on "display=$secondary_display")
fi

if [[ -n "$front_state" ]]; then
  IFS="$separator" read -r front_workspace front_name front_bundle front_display <<< "$front_state"
  arguments+=(
    --set aerospace.front_app
      drawing=on
      "display=$front_display"
      "label=$front_name"
  )
else
  arguments+=(--set aerospace.front_app drawing=off)
fi

if [[ "${SENDER:-}" == "aerospace_workspace_change" ]]; then
  "$SKETCHYBAR_BIN" --animate tanh 8 "${arguments[@]}"
else
  "$SKETCHYBAR_BIN" "${arguments[@]}"
fi

printf '%s\n' "$state_hash" > "$hash_file"

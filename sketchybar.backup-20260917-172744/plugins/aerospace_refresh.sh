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
  printf -v "count_$workspace" '%s' "0"
  printf -v "seen_$workspace" '%s' "$separator"
  printf -v "focused_$workspace" '%s' "false"
  printf -v "visible_$workspace" '%s' "false"
  printf -v "display_$workspace" '%s' ""

  for ((slot=1; slot<=MAX_APP_ICONS; slot++)); do
    printf -v "app_source_${workspace}_${slot}" '%s' ""
  done
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
    image_source="$(app_image_source "$bundle_id" "$application_name")"
    printf -v "app_source_${workspace}_${count_value}" '%s' "$image_source"
  fi
done <<< "$window_state"

arguments=()
main_display="${display_1:-}"
secondary_display="${display_6:-}"
status_displays=""

for workspace in {1..9}; do
  display_variable="display_$workspace"
  display_value="${!display_variable}"
  [[ -n "$display_value" ]] || continue

  if [[ ",$status_displays," != *",$display_value,"* ]]; then
    if [[ -n "$status_displays" ]]; then
      status_displays+=",$display_value"
    else
      status_displays="$display_value"
    fi
  fi
done

for workspace in {1..9}; do
  name="aerospace.space.$workspace"
  group_name="aerospace.group.$workspace"
  count_variable="count_$workspace"
  focused_variable="focused_$workspace"
  visible_variable="visible_$workspace"
  display_variable="display_$workspace"
  count_value="${!count_variable}"
  focused_value="${!focused_variable}"
  visible_value="${!visible_variable}"
  display_value="${!display_variable}"

  if [[ -z "$display_value" ]]; then
    arguments+=(--set "$name" drawing=off)
    arguments+=(--set "$group_name" drawing=off)
    for ((slot=1; slot<=MAX_APP_ICONS; slot++)); do
      arguments+=(--set "aerospace.app.$workspace.$slot" drawing=off)
    done
    if (( workspace != 5 && workspace != 9 )); then
      arguments+=(--set "aerospace.gap.$workspace" drawing=off)
    fi
    continue
  fi

  text_color="$EMPTY_TEXT"
  if [[ "$focused_value" == "true" ]]; then
    text_color="$FOCUSED_TEXT"
  elif [[ "$visible_value" == "true" ]]; then
    text_color="$VISIBLE_TEXT"
  elif (( count_value > 0 )); then
    text_color="$OCCUPIED_TEXT"
  fi

  overflow_count=0
  if (( count_value > MAX_APP_ICONS )); then
    overflow_count=$((count_value - MAX_APP_ICONS))
  fi

  if (( overflow_count > 0 )); then
    overflow_label="+$overflow_count"
    overflow_drawing=on
  else
    overflow_label=""
    overflow_drawing=off
  fi

  # Grouped style rule: the workspace number never changes meaning. Occupied
  # workspaces always show number + native app icons together, including the
  # focused workspace. Empty workspaces collapse to a narrow number-only item.
  if (( count_value > 0 )); then
    number_font="$NUMBER_FONT"
    number_padding="$WORKSPACE_OCCUPIED_PADDING"
    group_drawing=on
    group_background="$OCCUPIED_GROUP_BACKGROUND"
    group_border="$OCCUPIED_GROUP_BORDER"
    group_border_width=1

    if [[ "$focused_value" == "true" ]]; then
      group_background="$ACTIVE_BACKGROUND"
      group_border="$ACTIVE_BORDER"
    elif [[ "$visible_value" == "true" ]]; then
      group_border="$VISIBLE_BORDER"
    fi

    # The number participates in the occupied bracket instead of drawing a
    # second nested tile around itself.
    space_background="$TRANSPARENT"
    space_border="$TRANSPARENT"
    space_border_width=0
  else
    number_font="$EMPTY_NUMBER_FONT"
    number_padding="$WORKSPACE_EMPTY_PADDING"
    group_drawing=off
    group_background="$TRANSPARENT"
    group_border="$TRANSPARENT"
    group_border_width=0

    # Every empty workspace is a visible small tile. This was the biggest
    # missing piece compared with the reference mockup.
    space_background="$EMPTY_WORKSPACE_BACKGROUND"
    space_border="$EMPTY_WORKSPACE_BORDER"
    space_border_width=1
    if [[ "$focused_value" == "true" ]]; then
      space_background="$ACTIVE_BACKGROUND"
      space_border="$ACTIVE_BORDER"
    elif [[ "$visible_value" == "true" ]]; then
      space_border="$VISIBLE_BORDER"
    fi
  fi

  arguments+=(
    --set "$name"
      drawing=on
      "display=$display_value"
      "label=$overflow_label"
      "label.drawing=$overflow_drawing"
      icon.drawing=on
      "icon.font=$number_font"
      "icon.padding_left=$number_padding"
      "icon.padding_right=$number_padding"
      "icon.color=$text_color"
      "label.color=$text_color"
      "background.color=$space_background"
      "background.border_color=$space_border"
      "background.border_width=$space_border_width"
  )

  arguments+=(
    --set "$group_name"
      "drawing=$group_drawing"
      "background.color=$group_background"
      "background.border_color=$group_border"
      "background.border_width=$group_border_width"
  )

  for ((slot=1; slot<=MAX_APP_ICONS; slot++)); do
    app_name="aerospace.app.$workspace.$slot"
    source_variable="app_source_${workspace}_${slot}"
    image_source="${!source_variable}"

    if [[ -n "$image_source" ]]; then
      arguments+=(
        --set "$app_name"
          drawing=on
          "display=$display_value"
          "background.image=$image_source"
          background.image.drawing=on
      )
    else
      arguments+=(
        --set "$app_name"
          drawing=off
          "display=$display_value"
          background.image.drawing=off
      )
    fi
  done

  if (( workspace != 5 && workspace != 9 )); then
    # Consecutive empty workspaces stay compact. Any boundary touching an
    # occupied workspace gets the larger group gap so clusters are easy to
    # parse at a glance.
    next_workspace=$((workspace + 1))
    next_count_variable="count_$next_workspace"
    next_count_value="${!next_count_variable:-0}"
    gap_width="$EMPTY_WORKSPACE_GAP"
    if (( count_value > 0 || next_count_value > 0 )); then
      gap_width="$WORKSPACE_GROUP_GAP"
    fi

    arguments+=(
      --set "aerospace.gap.$workspace"
        drawing=on
        "display=$display_value"
        "width=$gap_width"
    )
  fi
done

if [[ -n "$main_display" ]]; then
  arguments+=(--set aerospace.spaces.main drawing=on "display=$main_display")
else
  arguments+=(--set aerospace.spaces.main drawing=off)
fi
if [[ -n "$secondary_display" ]]; then
  arguments+=(--set aerospace.spaces.secondary drawing=on "display=$secondary_display")
else
  arguments+=(--set aerospace.spaces.secondary drawing=off)
fi
if [[ -n "$status_displays" ]]; then
  arguments+=(
    --set system.time "display=$status_displays"
    --set system.wifi "display=$status_displays"
    --set system.volume "display=$status_displays"
    --set system.battery "display=$status_displays"
  )
fi

if [[ -n "$front_state" ]]; then
  IFS="$separator" read -r front_workspace front_name front_bundle front_display <<< "$front_state"
  front_image="$(app_image_source "$front_bundle" "$front_name")"
  arguments+=(
    --set aerospace.front_app
      drawing=on
      "display=$front_display"
      "label=$front_name"
      "icon.background.image=$front_image"
      icon.background.image.drawing=on
  )
else
  arguments+=(
    --set aerospace.front_app
      drawing=off
      icon.background.image.drawing=off
  )
fi

if [[ "${SENDER:-}" == "aerospace_workspace_change" ]]; then
  "$SKETCHYBAR_BIN" --animate tanh 8 "${arguments[@]}"
else
  "$SKETCHYBAR_BIN" "${arguments[@]}"
fi

printf '%s\n' "$state_hash" > "$hash_file"

#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export CONFIG_DIR

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/settings.sh"
source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/helpers/app_icon.sh"

runtime_prefix="${TMPDIR:-/tmp}/sketchybar-aerospace-${UID}"
lock_file="${runtime_prefix}.lockfile"
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

# The kernel releases this lock even if a refresh is killed. Waiting also
# lets a forced startup refresh run after an in-flight periodic refresh.
exec 9>"$lock_file"
/usr/bin/lockf -s -t 5 9 || exit 0

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

if [[ "${1:-}" != "--force" ]] &&
   [[ "${SENDER:-}" != "display_change" && "${SENDER:-}" != "system_woke" ]] &&
   [[ "$state_hash" == "$previous_hash" ]]; then
  exit 0
fi

for workspace in {1..9}; do
  printf -v "count_$workspace" '%s' "0"
  printf -v "seen_$workspace" '%s' "$separator"
  printf -v "focused_$workspace" '%s' "false"
  printf -v "visible_$workspace" '%s' "false"
  printf -v "display_$workspace" '%s' ""
  printf -v "apps_$workspace" '%s' ""
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
    apps_variable="apps_$workspace"
    apps_value="${!apps_variable}"
    printf -v "$apps_variable" '%s' "${apps_value:+$apps_value$separator}${bundle_id:-$application_name}"
  fi
done <<< "$window_state"

arguments=()
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

  apps_variable="apps_$workspace"
  app_label=" "
  label_drawing=off
  strip_arguments=(label.background.image.drawing=off label.width=0)
  if (( count_value > 0 )); then
    IFS="$separator" read -r -a app_identifiers <<< "${!apps_variable}"
    strip_key=$(printf '%s\n' "${app_identifiers[@]}" "$APP_IMAGE_WIDTH" "$APP_IMAGE_HEIGHT" \
      "$APP_IMAGE_SCALE" "$APP_IMAGE_PADDING" "$overflow_count" | /usr/bin/shasum -a 256 | /usr/bin/awk '{print $1}')
    strip_path="$APP_STRIP_CACHE/$strip_key.png"
    if [[ ! -f "$strip_path" || "$APP_STRIP_BIN" -nt "$strip_path" ]]; then
      "$APP_STRIP_BIN" "$strip_path" "$APP_IMAGE_WIDTH" "$APP_IMAGE_HEIGHT" \
        "$APP_IMAGE_SCALE" "$APP_IMAGE_PADDING" "$overflow_count" "${app_identifiers[@]}" || exit 1
    fi
    strip_width=$(( ${#app_identifiers[@]} * (APP_IMAGE_WIDTH + 2 * APP_IMAGE_PADDING) ))
    (( overflow_count > 0 )) && strip_width=$((strip_width + 24))
    label_drawing=on
    strip_arguments=("label.width=$strip_width" "label.background.image=$strip_path" label.background.image.drawing=on)
  fi

  # Every workspace uses the same capsule geometry. Content determines width:
  # empty = number only, occupied = number + app icons. Focus only changes style.
  number_font="$EMPTY_NUMBER_FONT"
  group_background="$WORKSPACE_BACKGROUND"
  group_border="$WORKSPACE_BORDER"
  group_border_width=1

  if (( count_value > 0 )); then
    number_font="$NUMBER_FONT"
  fi

  if [[ "$focused_value" == "true" ]]; then
    group_background="$ACTIVE_BACKGROUND"
    group_border="$ACTIVE_BORDER"
    group_border_width=1
  elif [[ "$visible_value" == "true" ]]; then
    group_background="$VISIBLE_BACKGROUND"
    group_border="$VISIBLE_BORDER"
  fi

  arguments+=(
    --set "$name"
      drawing=on
      "display=$display_value"
      "label=$app_label"
      "${strip_arguments[@]}"
      "label.drawing=$label_drawing"
      icon.drawing=on
      "icon.font=$number_font"
      "icon.padding_left=$WORKSPACE_NUMBER_PADDING"
      "icon.padding_right=$WORKSPACE_NUMBER_PADDING"
      "icon.color=$text_color"
      "label.color=$text_color"
      background.drawing=on
      "background.color=$group_background"
      "background.border_color=$group_border"
      "background.border_width=$group_border_width"
  )
done

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
    --set aerospace.front_app.gap
      drawing=on
      "display=$front_display"
    --set aerospace.front_app.icon
      drawing=on
      "display=$front_display"
      "background.image=$front_image"
      background.image.drawing=on
    --set aerospace.front_app.label
      drawing=on
      "display=$front_display"
      "label=$front_name"
    --set aerospace.front_app
      drawing=on
  )
else
  arguments+=(
    --set aerospace.front_app.gap drawing=off
    --set aerospace.front_app.icon drawing=off background.image.drawing=off
    --set aerospace.front_app.label drawing=off
    --set aerospace.front_app drawing=off
  )
fi

# Apply display, content and focus changes in one batch.
"$SKETCHYBAR_BIN" "${arguments[@]}" || exit 1

printf '%s\n' "$state_hash" > "$hash_file"

# Minimal AeroSpace workspace bar

This configuration creates two compact workspace capsules and one matching
system-status capsule. Workspaces 1–5 follow AeroSpace's main-monitor
assignment; workspaces 6–9 follow its secondary-monitor assignment. A small
focused-application capsule appears only on the currently focused display.
Time, Wi-Fi, volume, and battery status appear on the right of both displays.

## Files

- `sketchybarrc` sets up the transparent bar and loads the items.
- `colors.sh`, `settings.sh`, and `icons.sh` contain all visual and behavioral
  settings.
- `items/aerospace_workspaces.sh` creates the nine static clickable items, two
  brackets, and one hidden watcher.
- `items/front_app.sh` creates the focused-application capsule.
- `items/system_status.sh` creates the right-side status capsule.
- `plugins/aerospace_refresh.sh` performs one all-workspace query, one
  all-window query, and one focused-window query. It hashes the complete state
  and batches changes into one SketchyBar update.
- `helpers/app_icon.sh` is the single Nerd Font application icon map.
- `plugins/time.sh`, `wifi.sh`, `volume.sh`, and `battery.sh` update the
  right-side items. Wi-Fi uses interface state and its assigned IP address as
  a fallback when macOS does not reveal the current network name.

## Install and reload

```sh
mkdir -p "$HOME/.config/aerospace" "$HOME/.config/sketchybar"
cp aerospace/aerospace.toml "$HOME/.config/aerospace/aerospace.toml"
cp -R sketchybar/. "$HOME/.config/sketchybar/"
chmod +x "$HOME/.config/sketchybar/sketchybarrc" \
  "$HOME/.config/sketchybar/items/"*.sh \
  "$HOME/.config/sketchybar/plugins/"*.sh \
  "$HOME/.config/sketchybar/helpers/"*.sh
aerospace reload-config
brew services restart sketchybar
```

No dependency was added. The configuration uses the already installed
`Symbols Nerd Font` family.

## Customize

- Change the palette in `colors.sh`.
- Change dimensions, the four-icon limit, the four-second reconciliation
  interval, or `SHOW_DUPLICATE_WINDOWS` in `settings.sh`.
- Add bundle IDs or app-name fallbacks only in `helpers/app_icon.sh`.

## Troubleshooting

- Confirm both commands exist with `command -v aerospace sketchybar`.
- Confirm AeroSpace is running with `aerospace list-monitors`.
- Confirm "Displays have separate Spaces" is enabled in System Settings →
  Desktop & Dock → Mission Control. `defaults read com.apple.spaces
  spans-displays` should print `0`.
- Inspect service errors with
  `tail -n 100 /opt/homebrew/var/log/sketchybar/sketchybar.err.log`.
- Force a state refresh with
  `sketchybar --trigger aerospace_state_change REASON=manual`.

## Revert

The pre-change backup is in
`~/Downloads/MyMac/Projects/.config-backups/aerospace-sketchybar-20260804-2230/`.

```sh
cp "$HOME/Downloads/MyMac/Projects/.config-backups/aerospace-sketchybar-20260804-2230/aerospace.toml" \
  "$HOME/.config/aerospace/aerospace.toml"
mv "$HOME/.config/sketchybar" "$HOME/.config/sketchybar.before-revert"
cp -R "$HOME/Downloads/MyMac/Projects/.config-backups/aerospace-sketchybar-20260804-2230/sketchybar" \
  "$HOME/.config/sketchybar"
aerospace reload-config
brew services restart sketchybar
```

The four-second watcher is a single hidden SketchyBar item, not a background
loop. It prevents stale icons after lifecycle changes AeroSpace does not emit,
and updates visible properties only when the complete state hash changes.

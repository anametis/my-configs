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
- `helpers/app_icon.sh` is the single Symbols Nerd Font application icon map.
  It prefers AeroSpace's bundle identifier and then falls back to application
  name aliases. Unknown apps use the generic icon from `icons.sh`.
- `plugins/time.sh`, `wifi.sh`, `volume.sh`, and `battery.sh` update the
  right-side items. Wi-Fi uses interface state and its assigned IP address as
  a fallback when macOS does not reveal the current network name.

## Application icons

Application icon mappings are intentionally centralized in
`helpers/app_icon.sh`. The map covers common browsers, terminals, editors,
AI tools, communication apps, Apple apps, design/media tools, developer tools,
databases, Git clients, container/VM apps, office apps, password managers,
and VPN/proxy clients.

To add another app later:

1. Prefer its stable bundle identifier in the appropriate identifier section.
2. Add its displayed name only as a fallback/alias when needed.
3. Reuse a glyph from the existing `Symbols Nerd Font` family.
4. Leave the final fallback in place so unknown apps never render blank.

You can inspect what AeroSpace reports for currently open apps with:

```sh
aerospace list-windows --all --format '%{app-name} | %{app-bundle-id}' | sort -u
```

You can test the icon helper directly without reloading SketchyBar:

```sh
~/.config/sketchybar/helpers/app_icon.sh '' 'Obsidian'
~/.config/sketchybar/helpers/app_icon.sh '' 'ChatGPT'
~/.config/sketchybar/helpers/app_icon.sh '' 'Ghostty'
~/.config/sketchybar/helpers/app_icon.sh '' 'Docker Desktop'
~/.config/sketchybar/helpers/app_icon.sh '' 'Zed'
~/.config/sketchybar/helpers/app_icon.sh '' 'Finder'
~/.config/sketchybar/helpers/app_icon.sh '' 'Google Chrome'
```

## Install and reload

Replace the current config while keeping a backup:

```sh
mv "$HOME/.config/sketchybar" "$HOME/.config/sketchybar.backup"
mkdir -p "$HOME/.config/sketchybar"
cp -R /path/to/replacement/sketchybar/. "$HOME/.config/sketchybar/"
chmod +x "$HOME/.config/sketchybar/sketchybarrc" \
  "$HOME/.config/sketchybar/items/"*.sh \
  "$HOME/.config/sketchybar/plugins/"*.sh \
  "$HOME/.config/sketchybar/helpers/"*.sh
brew services restart sketchybar
```

If the files are already copied into `~/.config/sketchybar`, the reload command
is simply:

```sh
brew services restart sketchybar
```

For an app/window-only refresh after changing `helpers/app_icon.sh`, this is
usually enough and is faster than restarting the service:

```sh
~/.config/sketchybar/plugins/aerospace_refresh.sh --force
```

No dependency was added. The configuration continues to use the already
configured `Symbols Nerd Font` family.

## Customize

- Change the palette in `colors.sh`.
- Change dimensions, the four-icon limit, the four-second reconciliation
  interval, or `SHOW_DUPLICATE_WINDOWS` in `settings.sh`.
- Add bundle IDs or app-name fallbacks only in `helpers/app_icon.sh`.

## Troubleshooting

- Confirm both commands exist with `command -v aerospace sketchybar`.
- Confirm AeroSpace is running with `aerospace list-monitors`.
- Confirm the icon font is installed with:
  `fc-list 2>/dev/null | grep -i 'Symbols Nerd Font'` when `fc-list` is
  available, or inspect Font Book on macOS.
- Confirm "Displays have separate Spaces" is enabled in System Settings →
  Desktop & Dock → Mission Control. `defaults read com.apple.spaces
  spans-displays` should print `0`.
- Inspect service errors with
  `tail -n 100 /opt/homebrew/var/log/sketchybar/sketchybar.err.log`.
- Force a state refresh with
  `sketchybar --trigger aerospace_state_change REASON=manual`.
- To discover an unmapped app, run:
  `aerospace list-windows --all --format '%{app-name} | %{app-bundle-id}' | sort -u`.

## Revert

If you used the replacement command above:

```sh
rm -rf "$HOME/.config/sketchybar"
mv "$HOME/.config/sketchybar.backup" "$HOME/.config/sketchybar"
brew services restart sketchybar
```

The four-second watcher is a single hidden SketchyBar item, not a background
loop. It prevents stale icons after lifecycle changes AeroSpace does not emit,
and updates visible properties only when the complete state hash changes.

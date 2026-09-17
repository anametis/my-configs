# AeroSpace workspace bar

A Bash SketchyBar config with two workspace groups, a focused-app capsule, and
Time / Wi-Fi / Volume / Battery on the right. Workspaces 1–5 and 6–9 follow
AeroSpace's display assignments. The layout and native macOS app icons are
preserved.

## Appearance

Edit `colors.sh` for the opaque navy palette and `settings.sh` for geometry.
The transparent bar is 34pt tall, with 30pt outer capsules and 28pt workspace
pills. Focus uses a brighter 1pt border without changing the pill's size.

Useful settings:

| Setting | Default | Purpose |
| --- | --- | --- |
| `WORKSPACE_GROUP_GAP` | `12` | Space between workspace contents |
| `APP_IMAGE_SCALE` | `0.58` | Native workspace app icon scale |
| `FRONT_APP_IMAGE_SCALE` | `0.56` | Focused-app icon scale |
| `FRONT_APP_OUTER_GAP` | `18` | Gap before the focused app |
| `MAX_APP_ICONS` | `4` | App slots per workspace, then a `+N` label |
| `SHOW_DUPLICATE_WINDOWS` | `false` | One icon per app instead of per window |
| `RECONCILE_SECONDS` | `4` | Periodic AeroSpace reconciliation |
| `FRONT_APP_MAX_LENGTH` | `22` | Focused-app label limit |

App artwork uses bundle IDs, falling back to app names. The older glyph map in
`helpers/app_icon.sh` remains available for callers that use it directly.
A zero-width first item anchors bracket layering on both displays. Every
refresh reasserts the native window order, including when workspace data is
unchanged. Clicks also request a refresh, even on the already focused workspace.

## Updates and indicators

- Workspace events update the bar immediately; periodic polling catches missed
  window changes. Unchanged state skips rebuilding workspace content but still
  repairs window stacking. Wake and display changes force content updates.
- A native macOS file lock serializes refreshes and releases automatically if a
  refresh process dies. Failed SketchyBar updates are retried instead of cached.
- Battery charging reflects the actual charging state. Low and critical battery
  levels use amber and red.
- Volume queries both level and mute state. A failed query preserves the last
  reading instead of inventing a zero level.
- Wi-Fi uses the connected icon only when a network association is detected.
  An active interface with an IP address handles macOS hiding the network name.

## Reload and verify

After editing:

```sh
sketchybar --reload
```

Force workspace reconciliation:

```sh
~/.config/sketchybar/plugins/aerospace_refresh.sh --force
```

Run the isolated plugin checks. They use fake device data and do not change the
live bar, volume, network, or workspaces:

```sh
python3 ~/.config/sketchybar/test_plugins.py
```

Check shell syntax:

```sh
cd ~/.config/sketchybar
for f in sketchybarrc *.sh helpers/*.sh items/*.sh plugins/*.sh; do
  /bin/bash -n "$f" || exit 1
done
```

The runtime uses macOS's built-in Bash and utilities plus SketchyBar and
AeroSpace. Python 3 is only needed for the checks.

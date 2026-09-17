# Minimal AeroSpace workspace bar

This keeps the existing Bash + AeroSpace + SketchyBar structure and the same
color palette/capsule layout, but changes application rendering substantially:
workspace apps and the focused app use SketchyBar's native macOS app-image
source (`app.<bundle-id>`) instead of approximating brands with Nerd Font
glyphs. This revision also tunes spacing around those full-color native icons so
they read more like menu-bar indicators and less like miniature Dock icons.

That means installed apps such as Obsidian, ChatGPT, Ghostty, Docker Desktop,
OrbStack, VS Code, Zed, Finder, browsers, VPN clients, and other applications
can display their actual macOS application artwork without maintaining a logo
mapping or installing another app-icon font.

## What changed

- `settings.sh`
  - keeps the same 32px bar / 30px capsule layout
  - softens capsule corner radii
  - centralizes native app-image sizing and scale
  - separates system-icon font settings from app-image settings
- `items/aerospace_workspaces.sh`
  - keeps the same nine AeroSpace workspace items
  - pre-creates a small set of native app-image slots beside each workspace
  - keeps clicking a workspace number or app icon focused on that workspace
  - avoids repeatedly adding/removing SketchyBar items during normal updates
- `plugins/aerospace_refresh.sh`
  - continues using one all-workspace, one all-window, and one focused-window
    AeroSpace query
  - uses bundle IDs first and app names as a native-image fallback
  - fills the reusable image slots with `app.<bundle-id>`
  - displays `+N` when a workspace contains more apps than the configured limit
- `items/front_app.sh`
  - replaces the old chevron with the actual focused application's macOS icon
  - retains the existing focused-app name capsule
- `helpers/app_icon.sh`
  - adds the centralized `app_image_source` helper
  - retains the old Nerd Font map as a compatibility/fallback helper
- `sketchybarrc`
  - enables font smoothing and keeps the existing colors/overall structure
- `items/system_status.sh`
  - uses the explicit system icon font setting; its behavior is unchanged

No VPN/Docker/CPU/RAM polling widget was added. The existing right-side
Time / Wi-Fi / Volume / Battery group remains intentionally lightweight.

## Native app icon behavior

AeroSpace already supplies both values needed by SketchyBar:

```sh
%{app-name}
%{app-bundle-id}
```

The config prefers the bundle identifier:

```text
app.com.openai.chat
app.md.obsidian
app.com.mitchellh.ghostty
app.com.docker.docker
app.com.apple.finder
```

If a bundle ID is missing, it falls back to `app.<application name>`.
Because SketchyBar asks macOS for the installed application's artwork, there is
no per-application logo list to maintain for normal apps.

Inspect what AeroSpace reports with:

```sh
aerospace list-windows --all \
  --format '%{app-name} | %{app-bundle-id}' \
  | sort -u
```

## Replace your current config

Keep a backup first:

```sh
cd ~/.config
mv sketchybar "sketchybar.backup-$(date +%Y%m%d-%H%M%S)"
unzip ~/Downloads/sketchybar-native-icons.zip -d ~/.config
chmod +x ~/.config/sketchybar/sketchybarrc \
  ~/.config/sketchybar/helpers/*.sh \
  ~/.config/sketchybar/items/*.sh \
  ~/.config/sketchybar/plugins/*.sh
```

Then reload SketchyBar:

```sh
sketchybar --reload
```

A service restart is only needed if reload does not pick up the configuration:

```sh
brew services restart sketchybar
```

## Quick refresh after tuning icon size

After changing only app sizing/spacing values in `settings.sh`:

```sh
sketchybar --reload
```

After a window/app-state change, this can force the AeroSpace data refresh:

```sh
~/.config/sketchybar/plugins/aerospace_refresh.sh --force
```

## Appearance tuning

The most useful values are in `settings.sh`:

```sh
APP_IMAGE_WIDTH=17
APP_IMAGE_HEIGHT=16
APP_IMAGE_SCALE=0.58
APP_IMAGE_PADDING=2
FRONT_APP_IMAGE_SCALE=0.58
CORNER_RADIUS=9
ACTIVE_CORNER_RADIUS=7
WORKSPACE_GROUP_GAP=3
```

If the native icons feel slightly too large, try `APP_IMAGE_SCALE=0.54`.
If they feel too small, try `0.62`. Keep changes small because native macOS
icons carry much more visual weight than monochrome font glyphs.

Duplicate windows are deduplicated by default so two Chrome windows do not
produce two large Chrome icons side-by-side. To restore one icon per window:

```sh
export SHOW_DUPLICATE_WINDOWS=true
```

## Verification

Check shell syntax:

```sh
cd ~/.config/sketchybar
for f in sketchybarrc colors.sh settings.sh icons.sh helpers/*.sh items/*.sh plugins/*.sh; do
  bash -n "$f" || exit 1
done
```

Reload in the foreground for useful errors:

```sh
brew services stop sketchybar
sketchybar
```

Press `Ctrl-C` when finished, then restore the service with:

```sh
brew services start sketchybar
```

## Revert

```sh
rm -rf ~/.config/sketchybar
mv ~/.config/sketchybar.backup-YYYYMMDD-HHMMSS ~/.config/sketchybar
brew services restart sketchybar
```

## Focused workspace and spacing refinement

The focused workspace now hides its numeric label whenever it contains one or
more applications. Its native app icons become the workspace representation.
If the focused workspace is empty, the number remains visible so the workspace
never disappears from the bar.

Spacing is intentionally hierarchical:

- native icons within the same workspace are close enough to read as a group;
- workspace groups have a wider gap between them;
- the front-app capsule has a larger external gap from the workspace capsule;
- all main capsules are slightly shorter than the 32px bar for more vertical
  breathing room.

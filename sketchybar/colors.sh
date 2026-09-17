#!/usr/bin/env bash

# Transparent bar. All visible surfaces below are fully opaque to avoid
# wallpaper/display-dependent darkening.
export BAR_COLOR="0x00000000"

# Shared workspace rail: deliberately darker than each workspace capsule.
export CAPSULE_BACKGROUND="0xff0b111a"
export CAPSULE_BORDER="0xff202d3d"

# Every workspace uses this same base capsule, occupied or empty.
export WORKSPACE_BACKGROUND="0xff172130"
export WORKSPACE_BORDER="0xff2d3c4f"

# Focus/visibility states keep the same geometry and only strengthen styling.
export ACTIVE_BACKGROUND="0xff26364c"
export ACTIVE_BORDER="0xff8ca6c6"
export VISIBLE_BACKGROUND="0xff1d2a3a"
export VISIBLE_BORDER="0xff52677f"

# Current application capsule.
export FRONT_APP_BACKGROUND="0xff101823"
export FRONT_APP_BORDER="0xff2d3c4f"

# Text hierarchy.
export FOCUSED_TEXT="0xfff3eee2"
export VISIBLE_TEXT="0xffddd6c2"
export OCCUPIED_TEXT="0xffc8c5ba"
export EMPTY_TEXT="0xffa3a9b3"
export ACCENT_COLOR="0xffd9cfad"
export WARNING_COLOR="0xffe7b56a"
export CRITICAL_COLOR="0xffee8e8e"
export TRANSPARENT="0x00000000"

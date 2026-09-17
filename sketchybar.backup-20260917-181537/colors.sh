#!/usr/bin/env bash

# Same dark/warm palette, but deliberately opaque. This prevents the workspace
# rail from changing darkness depending on wallpaper/window content underneath
# each display and makes multi-display rendering deterministic.
export BAR_COLOR="0x00000000"

# Outer containers.
export CAPSULE_BACKGROUND="0xff171a22"
export CAPSULE_BORDER="0xff39414d"

# Occupied workspace groups. Empty workspaces intentionally have no separate
# tile/background: the lack of app icons already communicates that they are empty.
export OCCUPIED_GROUP_BACKGROUND="0xff252a34"
export OCCUPIED_GROUP_BORDER="0xff566272"

# Focused / visible state.
export ACTIVE_BACKGROUND="0xff323844"
export ACTIVE_BORDER="0xff7a8799"
export VISIBLE_BORDER="0xff687585"

# Current application capsule.
export FRONT_APP_BACKGROUND="0xff1c2029"
export FRONT_APP_BORDER="0xff4e5968"

# Text hierarchy.
export FOCUSED_TEXT="0xffeee6cf"
export VISIBLE_TEXT="0xffd0c8b2"
export OCCUPIED_TEXT="0xffb5b0a3"
export EMPTY_TEXT="0xff858791"
export ACCENT_COLOR="0xffd9cfad"
export TRANSPARENT="0x00000000"

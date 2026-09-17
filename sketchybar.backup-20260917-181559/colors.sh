#!/usr/bin/env bash

# Opaque dark surfaces keep the bar stable across displays and wallpapers.
export BAR_COLOR="0x00000000"

# Shared workspace/status rail: deep navy, close to the reference image.
export CAPSULE_BACKGROUND="0xff0f1621"
export CAPSULE_BORDER="0xff26364a"

# Occupied workspace groups: deliberately more separated from the rail than
# before so the grouping is visible at normal menu-bar scale.
export OCCUPIED_GROUP_BACKGROUND="0xff202a38"
export OCCUPIED_GROUP_BORDER="0xff566b84"

# Focused / visible workspace state.
export ACTIVE_BACKGROUND="0xff29364a"
export ACTIVE_BORDER="0xff8193aa"
export VISIBLE_BORDER="0xff6c8099"

# Current application capsule.
export FRONT_APP_BACKGROUND="0xff151d29"
export FRONT_APP_BORDER="0xff33465f"

# Text hierarchy keeps the existing warm accent but raises legibility.
export FOCUSED_TEXT="0xffeee6cf"
export VISIBLE_TEXT="0xffd8d0bb"
export OCCUPIED_TEXT="0xffc0bcaf"
export EMPTY_TEXT="0xff969aa5"
export ACCENT_COLOR="0xffd9cfad"
export TRANSPARENT="0x00000000"

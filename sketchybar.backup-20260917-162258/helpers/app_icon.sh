#!/usr/bin/env bash

# Central Nerd Font application icon map. The first argument may be a bundle
# identifier or an application name; a second application-name fallback is
# accepted when both are available from AeroSpace.
app_icon() {
  local identifier="${1:-}"
  local application_name="${2:-$identifier}"

  # Browsers
  case "$identifier" in
    com.google.Chrome|com.google.Chrome.*) printf ''; return ;;
    com.brave.Browser|com.brave.Browser.*) printf '󰙟'; return ;;
    com.apple.Safari|com.apple.Safari.*) printf ''; return ;;
    org.mozilla.firefox|org.mozilla.firefox.*) printf ''; return ;;
    com.microsoft.edgemac|com.microsoft.edgemac.*) printf '󰎇'; return ;;
  esac

  # Terminals, editors, and AI tools
  case "$identifier" in
    com.mitchellh.ghostty) printf '󰌨'; return ;;
    com.apple.Terminal|com.googlecode.iterm2|dev.warp.Warp-Stable) printf ''; return ;;
    com.microsoft.VSCode|com.microsoft.VSCodeInsiders|com.todesktop.230313mzl4w4u92) printf '󰨞'; return ;;
    com.openai.codex|com.openai.chat) printf '󰭻'; return ;;
    com.anthropic.claudefordesktop) printf '󰚩'; return ;;
  esac

  # Communication and productivity
  case "$identifier" in
    com.tinyspeck.slackmacgap) printf ''; return ;;
    com.hnc.Discord) printf ''; return ;;
    ru.keepcoder.Telegram) printf ''; return ;;
    com.apple.mail) printf ''; return ;;
    notion.id) printf '󱀒'; return ;;
    md.obsidian) printf '󰍊'; return ;;
    com.apple.finder) printf ''; return ;;
  esac

  # Media, utilities, and security
  case "$identifier" in
    com.adobe.PremierePro.*) printf '󰅧'; return ;;
    com.colliderli.iina|org.videolan.vlc) printf ''; return ;;
    com.spotify.client) printf ''; return ;;
    com.mac.xvpn|*vpn*|*VPN*) printf '󰘂'; return ;;
    su.ffg.happ) printf '󰑏'; return ;;
  esac

  # Name fallbacks cover apps whose bundle ID is missing or changes by build.
  case "$application_name" in
    Finder) printf '' ;;
    "Google Chrome") printf '' ;;
    Brave*) printf '󰙟' ;;
    Safari) printf '' ;;
    Firefox) printf '' ;;
    Ghostty|Terminal|iTerm2|Warp) printf '' ;;
    Code|"Visual Studio Code"|Cursor) printf '󰨞' ;;
    ChatGPT|Codex) printf '󰭻' ;;
    Claude) printf '󰚩' ;;
    Slack) printf '' ;;
    Discord) printf '' ;;
    Telegram) printf '' ;;
    Notion) printf '󱀒' ;;
    Obsidian) printf '󰍊' ;;
    IINA|VLC) printf '' ;;
    Spotify) printf '' ;;
    *VPN*|Happ) printf '󰘂' ;;
    *) printf '%s' "${GENERIC_APP_ICON:-󰓆}" ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  app_icon "${1:-}" "${2:-}"
fi

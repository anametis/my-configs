#!/usr/bin/env bash

# Central Symbols Nerd Font application icon map.
#
# AeroSpace gives us both an app bundle identifier and a displayed app name.
# Bundle identifiers are preferred because they are more stable; app-name aliases
# are the fallback for apps whose IDs vary by release/channel or are unavailable.
#
# Keep this file compatible with the Bash shipped by macOS (3.2): deliberately
# use grouped case patterns instead of associative arrays or newer Bash syntax.
app_icon() {
  local identifier="${1:-}"
  local application_name="${2:-$identifier}"

  # ---------------------------------------------------------------------------
  # Browsers
  # ---------------------------------------------------------------------------
  case "$identifier" in
    com.google.Chrome|com.google.Chrome.*) printf ''; return ;;
    com.apple.Safari|com.apple.Safari.*) printf ''; return ;;
    org.mozilla.firefox|org.mozilla.firefox.*) printf ''; return ;;
    com.brave.Browser|com.brave.Browser.*) printf '󰙟'; return ;;
    com.microsoft.edgemac|com.microsoft.edgemac.*) printf '󰎇'; return ;;
    company.thebrowser.Browser|company.thebrowser.Browser.*) printf ''; return ;;
    com.vivaldi.Vivaldi|com.vivaldi.Vivaldi.*) printf ''; return ;;
    com.operasoftware.Opera|com.operasoftware.Opera.*) printf ''; return ;;
  esac

  # ---------------------------------------------------------------------------
  # Terminals, shells, editors, IDEs
  # ---------------------------------------------------------------------------
  case "$identifier" in
    com.mitchellh.ghostty) printf '󰌨'; return ;;
    com.apple.Terminal|com.googlecode.iterm2|dev.warp.Warp-Stable|dev.warp.Warp-Preview) printf ''; return ;;
    org.alacritty|net.kovidgoyal.kitty|com.github.wez.wezterm) printf ''; return ;;

    com.microsoft.VSCode|com.microsoft.VSCodeInsiders|com.todesktop.230313mzl4w4u92) printf '󰨞'; return ;;
    dev.zed.Zed|dev.zed.Zed-Preview) printf '󰨞'; return ;;
    com.sublimetext.3|com.sublimetext.4|com.panic.Nova|com.barebones.bbedit) printf ''; return ;;
    com.apple.dt.Xcode|com.apple.dt.Xcode.*) printf ''; return ;;
    com.jetbrains.datagrip) printf ''; return ;;
    com.jetbrains.*|com.google.android.studio) printf ''; return ;;
  esac

  # ---------------------------------------------------------------------------
  # AI assistants and knowledge / productivity apps
  # ---------------------------------------------------------------------------
  case "$identifier" in
    com.openai.chat|com.openai.codex) printf '󰭻'; return ;;
    com.anthropic.claudefordesktop) printf '󰚩'; return ;;
    md.obsidian) printf '󰍊'; return ;;
    notion.id|notion.id.*) printf '󱀒'; return ;;
    com.linear|com.linear.*) printf '󰄬'; return ;;
    com.culturedcode.ThingsMac) printf '󰄬'; return ;;
    com.todoist.mac.Todoist|com.todoist.mac.Todoist.*) printf '󰄬'; return ;;
    net.shinyfrog.bear) printf '󰈙'; return ;;
  esac

  # ---------------------------------------------------------------------------
  # Communication
  # ---------------------------------------------------------------------------
  case "$identifier" in
    com.tinyspeck.slackmacgap) printf ''; return ;;
    com.hnc.Discord) printf ''; return ;;
    ru.keepcoder.Telegram|org.telegram.desktop) printf ''; return ;;
    net.whatsapp.WhatsApp|net.whatsapp.WhatsApp.*) printf ''; return ;;
    com.microsoft.teams|com.microsoft.teams2) printf ''; return ;;
    us.zoom.xos) printf ''; return ;;
    com.apple.MobileSMS) printf '󰍦'; return ;;
    com.apple.FaceTime) printf ''; return ;;
  esac

  # ---------------------------------------------------------------------------
  # Apple apps and common macOS utilities
  # ---------------------------------------------------------------------------
  case "$identifier" in
    com.apple.finder) printf ''; return ;;
    com.apple.mail) printf ''; return ;;
    com.apple.iCal) printf ''; return ;;
    com.apple.Notes) printf '󰈙'; return ;;
    com.apple.reminders) printf '󰄬'; return ;;
    com.apple.ActivityMonitor) printf ''; return ;;
    com.apple.systempreferences|com.apple.SystemPreferences) printf ''; return ;;
    com.apple.Preview) printf ''; return ;;
    com.apple.Photos) printf ''; return ;;
    com.apple.TextEdit) printf '󰈙'; return ;;
    com.apple.QuickTimePlayerX) printf ''; return ;;
    com.apple.Music) printf ''; return ;;
    com.apple.TV) printf ''; return ;;
    com.apple.podcasts) printf ''; return ;;
    com.apple.iWork.Pages) printf '󰈙'; return ;;
    com.apple.iWork.Numbers) printf '󰱾'; return ;;
    com.apple.iWork.Keynote) printf '󰐨'; return ;;
    com.apple.keychainaccess) printf ''; return ;;
  esac

  # ---------------------------------------------------------------------------
  # Design, creative, media
  # ---------------------------------------------------------------------------
  case "$identifier" in
    com.figma.Desktop|com.figma.Desktop.*) printf ''; return ;;
    com.bohemiancoding.sketch3) printf ''; return ;;
    com.seriflabs.affinity*) printf ''; return ;;
    org.blenderfoundation.blender) printf ''; return ;;
    com.adobe.Photoshop|com.adobe.Photoshop.*|com.adobe.Illustrator|com.adobe.Illustrator.*|com.adobe.PremierePro.*) printf ''; return ;;
    com.colliderli.iina|org.videolan.vlc) printf ''; return ;;
    com.spotify.client) printf ''; return ;;
  esac

  # ---------------------------------------------------------------------------
  # Developer tools, databases, source control, containers / virtualisation
  # ---------------------------------------------------------------------------
  case "$identifier" in
    com.postmanlabs.mac|com.postmanlabs.mac.*) printf ''; return ;;
    com.konghq.Insomnia|com.insomnia.app) printf ''; return ;;
    com.tinyapp.TablePlus) printf ''; return ;;
    org.jkiss.dbeaver.core.product) printf ''; return ;;
    com.github.GitHubClient) printf ''; return ;;
    com.DanPristupov.Fork|com.fournova.Tower3|com.torusknot.SourceTree*) printf ''; return ;;
    com.docker.docker|com.docker.docker.*) printf ''; return ;;
    dev.kdrag0n.MacVirt|dev.orbstack.OrbStack) printf ''; return ;;
    io.podman_desktop.PodmanDesktop|io.podman-desktop.PodmanDesktop) printf ''; return ;;
    com.utmapp.UTM|com.parallels.desktop.console|com.vmware.fusion) printf '󰘸'; return ;;
  esac

  # ---------------------------------------------------------------------------
  # Office / documents
  # ---------------------------------------------------------------------------
  case "$identifier" in
    com.microsoft.Word) printf '󰈬'; return ;;
    com.microsoft.Excel) printf '󰈛'; return ;;
    com.microsoft.Powerpoint) printf '󰈧'; return ;;
    com.adobe.Acrobat.Pro|com.adobe.Reader) printf ''; return ;;
  esac

  # ---------------------------------------------------------------------------
  # Launchers, password managers, system utilities
  # ---------------------------------------------------------------------------
  case "$identifier" in
    com.raycast.macos|com.raycast.macos.*) printf ''; return ;;
    com.runningwithcrayons.Alfred|com.runningwithcrayons.Alfred-Preferences) printf ''; return ;;
    com.1password.1password|com.1password.1password7) printf ''; return ;;
    com.bitwarden.desktop|org.keepassxc.keepassxc) printf ''; return ;;
  esac

  # ---------------------------------------------------------------------------
  # VPN, proxy and networking clients
  # Keep explicit IDs here, then broad name aliases below for clients whose
  # bundle IDs vary between App Store/direct/GitHub builds.
  # ---------------------------------------------------------------------------
  case "$identifier" in
    net.mullvad.vpn|ch.protonvpn.mac|com.protonvpn.mac) printf '󰘂'; return ;;
    io.tailscale.ipn.macos|com.wireguard.macos|net.tunnelblick.tunnelblick) printf '󰘂'; return ;;
    com.west2online.ClashX|com.west2online.ClashX.Pro) printf '󰘂'; return ;;
    su.ffg.happ|com.mac.xvpn) printf '󰘂'; return ;;
    *v2ray*|*V2Ray*|*clash*|*Clash*|*mihomo*|*Mihomo*|*hiddify*|*Hiddify*|*sing-box*|*VPN*|*vpn*) printf '󰘂'; return ;;
  esac

  # ---------------------------------------------------------------------------
  # Application-name aliases
  # These intentionally come after bundle IDs. Group aliases that share an icon
  # so adding a new spelling does not create a second source of truth.
  # ---------------------------------------------------------------------------
  case "$application_name" in
    # Browsers
    "Google Chrome"|"Google Chrome Canary") printf '' ;;
    Safari|"Safari Technology Preview") printf '' ;;
    Firefox|"Firefox Developer Edition"|"Firefox Nightly") printf '' ;;
    Brave|"Brave Browser"|"Brave Browser Beta"|"Brave Browser Nightly") printf '󰙟' ;;
    "Microsoft Edge"|"Microsoft Edge Beta"|"Microsoft Edge Dev"|"Microsoft Edge Canary") printf '󰎇' ;;
    Arc|"Arc Beta"|Vivaldi|Opera|Orion) printf '' ;;

    # Terminals / editors / IDEs
    Ghostty) printf '󰌨' ;;
    Terminal|iTerm|iTerm2|Warp|"Warp Preview"|Alacritty|kitty|Kitty|WezTerm|Hyper) printf '' ;;
    Code|"Visual Studio Code"|"Visual Studio Code - Insiders"|Cursor|Zed|"Zed Preview") printf '󰨞' ;;
    Xcode|Sublime*|Nova|BBEdit|"Android Studio"|IntelliJ*|WebStorm*|PyCharm*|GoLand*|Rider*|CLion*) printf '' ;;

    # AI / knowledge / productivity
    ChatGPT|Codex) printf '󰭻' ;;
    Claude) printf '󰚩' ;;
    Obsidian) printf '󰍊' ;;
    Notion|"Notion Calendar") printf '󱀒' ;;
    Linear|Things|"Things 3"|Todoist|Reminders) printf '󰄬' ;;
    Bear|Notes|Craft) printf '󰈙' ;;

    # Communication
    Slack) printf '' ;;
    Discord|"Discord Canary"|"Discord PTB") printf '' ;;
    Telegram|"Telegram Desktop") printf '' ;;
    WhatsApp|"WhatsApp Beta") printf '' ;;
    "Microsoft Teams"|Teams) printf '' ;;
    zoom.us|Zoom|FaceTime) printf '' ;;
    Messages) printf '󰍦' ;;

    # Apple / macOS
    Finder) printf '' ;;
    Mail) printf '' ;;
    Calendar) printf '' ;;
    "Activity Monitor") printf '' ;;
    "System Settings"|"System Preferences") printf '' ;;
    Preview|Photos) printf '' ;;
    TextEdit) printf '󰈙' ;;
    "QuickTime Player"|TV) printf '' ;;
    Music|"Apple Music") printf '' ;;
    Podcasts) printf '' ;;
    Pages) printf '󰈙' ;;
    Numbers) printf '󰱾' ;;
    Keynote) printf '󰐨' ;;
    "Keychain Access") printf '' ;;

    # Creative / media
    Figma|Sketch|"Affinity Designer"|"Affinity Photo"|"Affinity Publisher"|"Adobe Photoshop"|"Adobe Illustrator"|"Adobe Premiere Pro") printf '' ;;
    Blender) printf '' ;;
    IINA|VLC|"VLC media player") printf '' ;;
    Spotify) printf '' ;;

    # Developer tools / databases / Git / containers
    Postman|Insomnia) printf '' ;;
    TablePlus|DBeaver|"DataGrip") printf '' ;;
    "GitHub Desktop") printf '' ;;
    Fork|Tower|Sourcetree|SourceTree) printf '' ;;
    Docker|"Docker Desktop") printf '' ;;
    OrbStack) printf '' ;;
    "Podman Desktop") printf '' ;;
    UTM|Parallels*|"VMware Fusion") printf '󰘸' ;;

    # Office / documents
    "Microsoft Word"|Word) printf '󰈬' ;;
    "Microsoft Excel"|Excel) printf '󰈛' ;;
    "Microsoft PowerPoint"|PowerPoint) printf '󰈧' ;;
    "Adobe Acrobat"|"Adobe Acrobat Reader"|"Acrobat Reader") printf '' ;;

    # Launchers / security
    Raycast) printf '' ;;
    Alfred*) printf '' ;;
    "1Password"|Bitwarden|KeePassXC) printf '' ;;

    # VPN / proxy / network clients. These patterns cover common alternate names
    # without requiring us to guess every vendor-specific bundle identifier.
    *VPN*|*Vpn*|*vpn*|V2Ray*|v2ray*|"v2rayN"|"V2RayU"|"V2RayX"|Clash*|clash*|Mihomo*|mihomo*|Hiddify*|hiddify*|"sing-box"|Tailscale|WireGuard|Tunnelblick|Mullvad*|"Proton VPN"|ProtonVPN|Happ|"WhiteVPN Desktop") printf '󰘂' ;;

    *) printf '%s' "${GENERIC_APP_ICON:-󰓆}" ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  app_icon "${1:-}" "${2:-}"
fi

-- =============================================================================
-- enyxma :: Core Environment Variables
-- =============================================================================

-- XDG ve Masaüstü Tanımları
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Qt Araç Takımı (Quickshell ve modern QtQuick uygulamaları için)
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- GTK ve GDK
hl.env("GDK_BACKEND", "wayland,x11,*")

-- SDL ve Oyun/Grafik Motorları
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- Tarayıcılar ve Electron (Wayland Native)
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- İmleç Boyutları
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

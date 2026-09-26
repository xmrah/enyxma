-- =============================================================================
-- enyxma :: Window Manager Layout & Input
-- =============================================================================

-- Varsayılan Monitör Kuralı (Her ekranda otomatik çözünürlük ve ölçek)
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- Girdi ve Pencere Düzeni Yapılandırması
hl.config({
    input = {
        kb_layout  = "us,tr",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            tap_to_click   = true,
        },
        sensitivity = 0,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        force_default_wallpaper  = 0,
    },
})

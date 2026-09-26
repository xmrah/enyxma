-- =============================================================================
-- enyxma :: Window & Layer Rules
-- =============================================================================

-- Pencere Kuralları (Window Rules)
hl.window_rule({
    name           = "suppress-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = { class = "^$", title = "^$", xwayland = true, float = true },
    no_focus = true,
})

-- Sistem ve İletişim Pencerelerini Float Yap
hl.window_rule({
    name  = "floating-dialogs",
    match = { class = "(pavucontrol|nm-connection-editor|blueman-manager|polkit.*)" },
    float = true,
})

-- Quickshell Katman Kuralları (Layer Rules - Frosted Glass Efekti)
hl.layer_rule({
    name         = "quickshell-blur",
    match        = { namespace = "^quickshell.*" },
    blur         = true,
    ignore_alpha = 0.5,
})

-- =============================================================================
-- enyxma :: Look, Feel, Borders & Animations
-- Tema motorundan beslenen görsel ayarlar.
-- =============================================================================

hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 2,

        -- Varsayılan: Void Black (Minimalist derin siyah + cyan vurgu)
        -- Quickshell IPC ile anlık güncellenebilir
        col = {
            active_border   = { colors = { "rgba(00e5ffee)", "rgba(1a1a22ee)" }, angle = 45 },
            inactive_border = "rgba(15151caa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        active_opacity   = 0.98,
        inactive_opacity = 0.92,

        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 3,
            color        = 0x66000000,
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 2,
            vibrancy          = 0.20,
            new_optimizations = true,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Yumuşak Bezier Eğrileri
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })

-- Dinamik ve Tepkisel Animasyonlar
hl.animation({ leaf = "global",        enabled = true, speed = 5,   bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4,   bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4,   bezier = "easeOutQuint",   style = "popin 85%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 3,   bezier = "easeInOutCubic", style = "popin 85%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 3,   bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 2.5, bezier = "easeInOutCubic" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 4,   bezier = "easeOutQuint",   style = "slide" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.5, bezier = "easeOutQuint" })

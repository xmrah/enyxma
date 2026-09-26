-- =============================================================================
-- enyxma :: Keybindings & Mouse Binds
-- =============================================================================

local mainMod = "SUPER"

-- -----------------------------------------------------------------------------
-- Temel Uygulamalar & Kabuk Entegrasyonu
-- -----------------------------------------------------------------------------

-- Terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))

-- Quickshell Uygulama Başlatıcı (AppLauncher)
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("quickshell ipc call launcher toggle"))

-- Quickshell Kontrol Merkezi (ControlCenter - Ses, Parlaklık, Tema, Güç)
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("quickshell ipc call controlCenter toggle"))

-- Dosya Yöneticisi
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar || dolphin || kitty -e yazi"))

-- Pencere Kapatma & Durum Değiştirme
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.toggle_floating())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(0))

-- Oturum Kapatma / Güç Menüsü
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("quickshell ipc call controlCenter openPower"))

-- -----------------------------------------------------------------------------
-- Ekran Görüntüsü (Screenshot)
-- -----------------------------------------------------------------------------
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send 'Ekran Alıntısı' 'Panoya kopyalandı'"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send 'Ekran Alıntısı' 'Panoya kopyalandı'"))

-- -----------------------------------------------------------------------------
-- Pencere Odaklama & Taşıma (HJKL ve Ok Tuşları)
-- -----------------------------------------------------------------------------
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- -----------------------------------------------------------------------------
-- Çalışma Alanları (Workspaces 1 - 10)
-- -----------------------------------------------------------------------------
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Fare ile Çalışma Alanı Değiştirme
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Fare ile Pencere Sürükleme ve Boyutlandırma
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- -----------------------------------------------------------------------------
-- Donanım & Medya Tuşları (Quickshell OSD tetikleyici ile)
-- -----------------------------------------------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && quickshell ipc call osd notifyVolume"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && quickshell ipc call osd notifyVolume"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && quickshell ipc call osd notifyVolume"),       { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                                              { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+ && quickshell ipc call osd notifyBrightness"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%- && quickshell ipc call osd notifyBrightness"), { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

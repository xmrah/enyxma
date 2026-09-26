-- =============================================================================
-- enyxma :: Hyprland Configuration (Pure Lua 0.55+)
-- Sıfırdan tasarlanmış, modüler ve yekpare masaüstü mimarisi.
-- =============================================================================

-- Modül arama yolunu dinamik olarak dosyanın bulunduğu dizine göre ayarla
local src = debug.getinfo(1, "S").source:sub(2)
local base_dir = src:match("(.*/)") or "/etc/xdg/hypr/"
package.path = base_dir .. "?.lua;" .. base_dir .. "?/init.lua;" .. package.path

-- Modül yükleme yardımcısı (Hata durumunda çöküşü önler ve konsola yazar)
local function safe_require(mod_name)
    local ok, mod = pcall(require, mod_name)
    if not ok then
        print("[enyxma:hyprland.lua] Modül yüklenemedi: " .. mod_name .. " -> " .. tostring(mod))
    end
    return mod
end

-- 1. Temel Ortam Değişkenleri (Wayland, Qt, GTK, XDG)
safe_require("core.env")

-- 2. Pencere Düzeni ve Girdi Ayarları (Dwindle, Klavye, Fare)
safe_require("wm.layout")

-- 3. Görsel Ayarlar ve Animasyonlar (Temadan beslenen kenarlıklar, cam efekti)
safe_require("ui.borders")

-- 4. Pencere ve Katman Kuralları (Quickshell blur, dialog kuralları)
safe_require("wm.rules")

-- 5. Tuş ve Fare Kısayolları (Uygulama başlatıcılar, pencere yönetimi)
safe_require("wm.binds")

-- 6. Oturum Başlatıcılar (UWSM finalize, Quickshell servisleri)
safe_require("core.autostart")

-- =============================================================================
-- enyxma :: Autostart Services
-- =============================================================================

-- UWSM Finalize: graphical-session.target'ı tetikleyerek systemd servislerini ayağa kaldırır
hl.exec_cmd("command -v uwsm >/dev/null 2>&1 && uwsm finalize")

-- Quickshell Masaüstü Kabuğu (TopBar, AppLauncher, ControlCenter, OSD)
-- Eğer systemd servisi olarak aktif değilse doğrudan başlat
hl.exec_cmd("pgrep -x quickshell >/dev/null || quickshell")

-- Pano Yönetimi (Clipboard history)
hl.exec_cmd("command -v wl-paste >/dev/null 2>&1 && wl-paste --type text --watch cliphist store")
hl.exec_cmd("command -v wl-paste >/dev/null 2>&1 && wl-paste --type image --watch cliphist store")

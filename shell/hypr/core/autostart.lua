-- =============================================================================
-- enyxma :: Autostart Services
-- =============================================================================

-- UWSM Finalize: graphical-session.target'ı tetikleyerek systemd servislerini ayağa kaldırır
hl.exec_cmd("command -v uwsm >/dev/null 2>&1 && uwsm finalize")

-- Quickshell Masaüstü Kabuğu (TopBar, AppLauncher, ControlCenter, OSD)
hl.exec_cmd("pgrep -x quickshell >/dev/null || quickshell -p /etc/xdg/quickshell/shell.qml")

-- Pano Yönetimi (Clipboard history)
hl.exec_cmd("command -v wl-paste >/dev/null 2>&1 && wl-paste --type text --watch cliphist store")
hl.exec_cmd("command -v wl-paste >/dev/null 2>&1 && wl-paste --type image --watch cliphist store")

-- Canlı ISO Kurulum Ortamı Otomatik Başlatıcı (Yalnızca canlı oturumda 'nixos' kullanıcısı için)
hl.exec_cmd("[ \"$(whoami)\" = 'nixos' ] && command -v enyxma-install >/dev/null 2>&1 && (pgrep -f 'enyxma installer' >/dev/null || kitty --title 'enyxma installer' enyxma-install)")

# Araştırma Notu: Quickshell + Hyprland + Lua Ekosistemi (Sıfırdan Tasarım)

- **Tarih:** 2026-09-26
- **Kaynaklar:**
  - https://quickshell.org/docs/
  - https://wiki.hypr.land/configuring/
  - https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
  - https://github.com/outfoxxed/quickshell
- **Konu:** Kimsenin kişisel dotfiles'ını kopyalamadan, sıfırdan, tek ve yekpare (Omarchy felsefesi) bir masaüstü ekosistemi inşası.

---

## 1. Saf Lua Hyprland Mimarisi (Hyprland 0.55+)
Hyprland artık Lua yapılandırmasını yerel (first-party) olarak desteklemektedir. Harici C++ eklentilerine ihtiyaç yoktur.

### En İyi Pratikler
1. **Modüler Dizin Yapısı:**
   Tek ve devasa bir `hyprland.lua` yerine sorumlulukların ayrıldığı bir yapı:
   ```text
   hypr/
   ├── hyprland.lua         # Giriş noktası ve pcall modül yükleyici
   ├── core/
   │   ├── env.lua          # Wayland, XDG, imleç ortam değişkenleri
   │   └── autostart.lua    # UWSM finalize ve servis başlatıcılar
   ├── wm/
   │   ├── binds.lua        # Tuş ve fare kısayolları (hl.bind, hl.dsp)
   │   ├── rules.lua        # Pencere ve layer kuralları (windowrulev2, layerrule)
   │   └── layout.lua       # Dwindle/Master dizilim ayarları
   └── ui/
       └── borders.lua      # Tema motorundan beslenen kenarlık ve köşe ayarları
   ```
2. **Dinamik Modül Yükleme:**
   `package.path` manipülasyonu yerine `debug.getinfo` veya ortam değişkeni (`HOME`) üzerinden dinamik ve güvenli `dofile` mekanizması kullanılmalıdır.
3. **UWSM Entegrasyonu:**
   Oturum yönetimi UWSM'ye emanet edilmeli; `hl.exec_cmd("uwsm finalize")` çağrısıyla `graphical-session.target` tetiklenmelidir.

---

## 2. Quickshell Yerel Entegrasyonu
Quickshell, QtQuick/QML tabanlı modern bir masaüstü kabuk geliştirme araç takımıdır.

### En İyi Pratikler
1. **`Quickshell.Hyprland` Modülü:**
   - Dışarıdan `hyprctl` komutları çalıştırmak yerine, Quickshell'in yerel `Hyprland` singleton nesnesi kullanılmalıdır.
   - Doğrudan Unix soketi (`.socket2.sock`) üzerinden olayları dinler (`rawEvent`).
   - `Hyprland.dispatch()` ile doğrudan komut gönderir (gecikmesiz ve hafif).
   - Çalışma alanları ve pencereler reaktif QML modelleri (`workspaces`, `focusedWorkspace`, `monitors`) ile izlenir.
2. **Katman Yönetimi (WlrLayershell):**
   - Panel pencereleri: `WlrLayershell.layer: WlrLayer.Top`
   - Pop-up menüler ve launcher: `WlrLayershell.layer: WlrLayer.Overlay`
   - Bu ayrım, kurulum pencereleri veya tam ekran uygulamalarla menülerin çakışmasını engeller.
3. **Servis Olarak Çalışma:**
   Quickshell doğrudan UWSM `graphical-session.target`'a bağlı bir systemd kullanıcı servisi (`quickshell.service`) olarak çalışmalıdır.

---

## 3. Tema Ekosistemi (Stylix Olmadan Yerel Mimari)
Hedef: Stylix gibi soyut ve hantal bir katman olmadan, Omarchy gibi "her şeyin tek bir tema kalbinden beslendiği" native bir ekosistem.

### Mimari Tasarım
1. **Tek Doğruluk Kaynağı (Single Source of Truth):**
   - Renk ve tipografi paletleri merkezi bir deklaratif veri yapısında (Nix veya JSON) tanımlanır.
   - İlk sürümde 4-5 seçkin varyasyon:
     1. *Void Black* (Minimalist saf siyah, derin gri, cam göbeği vurgu)
     2. *Cyber Matrix* (Koyu zümrüt yeşili, neon hatlar)
     3. *Ghost White / Solarized* (Yüksek kontrastlı aydınlık tema)
     4. *Slate Cobalt* (Soğuk mavi/lacivert teknik tema)
     5. *Blood Amber* (Koyu kızıl/kehribar saldırgan tema)
2. **Quickshell Tema Motoru (`Theme.qml`):**
   - QML tarafında singleton olarak tüm bileşenlere (TopBar, AppLauncher, ControlCenter, OSD) renk token'larını dağıtır.
3. **Uygulamalar Arası Senkronizasyon:**
   - Tema değiştiğinde Quickshell bir IPC sinyali üretir veya yapılandırmayı günceller:
     - Hyprland aktif kenarlık rengi anında güncellenir (`hyprctl keyword general:col.active_border ...`).
     - Kitty terminal renkleri soket üzerinden canlı güncellenir (`kitty @ set-colors`).
     - Bildirimler ve OSD anında yeni palete geçer.

---

## 4. Sıfırdan Tasarım ve İzolasyon İlkeleri
- **Sıfır Kişisel Veri / Sızıntı:** Kullanıcı adı, e-posta, özel donanım yolları (`/home/xmrah`, `/persist/nixos-config`) hiçbir dosyada yer alamaz.
- **Kendi Kendine Yetebilirlik:** Depo klonlandığında ve derlendiğinde harici hiçbir kişisel dotfiles deposuna bağımlı olmadan eksiksiz çalışmalıdır.
- **Komponent Odaklılık:** TopBar, AppLauncher, ControlCenter, OSD ve Wallpaper birbirinden bağımsız, test edilebilir QML modülleri olarak yazılmalıdır.

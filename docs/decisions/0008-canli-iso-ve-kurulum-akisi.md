# ADR-0008: Canlı ISO Kullanıcı Deneyimi ve İnteraktif Kurulum Akışı

- **Tarih:** 2026-09-26
- **Durum:** Kabul Edildi

## Bağlam

enyxma canlı ISO'sunun (Live ISO) sanal makineye (VM) veya fiziksel SSD'ye kurulumu sırasında sunulacak kullanıcı deneyimi ve kurulum sihirbazı tasarımı için 3 seçenek değerlendirilmiştir:

1. **Doğrudan Canlı Hyprland + Quickshell Masaüstü:** ISO açılışında masaüstü ve 5 temalı Quickshell kabuğu anında başlar; interaktif `enyxma-install` sihirbazı terminal penceresinde kullanıcıyı karşılar.
2. **Doğrudan Tam Ekran TUI Yükleyici:** Yalnızca ncurses konsol arayüzü açılır, masaüstü sunulmaz.
3. **Calamares Grafiksel Yükleyici:** Geleneksel Calamares aracı entegre edilir.

## Karar

**Doğrudan Canlı Hyprland + Quickshell Masaüstü** modeli kabul edildi:

- **Canlı Oturum Karşılaması:** ISO açıldığında `nixos` kullanıcısı ile doğrudan Wayland, Hyprland ve Quickshell TopBar/ControlCenter yüklenir. Kullanıcı kurulum yapmadan önce 5 temayı ve donanım tepkisini canlı olarak deneyimleyebilir.
- **İnteraktif Kurulum Sihirbazı (`enyxma-install`):**
  - Kitty uçbirimi içinde açılan, ANSI renk paletli, pürüzsüz kurulum aracı.
  - Adımlar:
    1. Disk Seçimi (`lsblk` taraması ve seçim).
    2. Tam Disk Şifreleme (LUKS2 Argon2id) tercihi ve parola belirleme.
    3. Varsayılan Tema Tercihi (5 seçkin varyasyon: Void Black, Cyber Matrix, Ghost White, Slate Cobalt, Blood Amber).
    4. Operatör Kullanıcı Adı ve Şifresi.
    5. Secure Boot (Lanzaboote) etkinleştirme tercihi.
    6. `disko` ile otomatik bölümlendirme (`tmpfs /`, `@nix`, `@persist`, `@swap`, `/boot`).
    7. `nixos-install` ile tek aşamada kurulum ve yeniden başlatma onayı.

## Neden

- Kullanıcıya kuruluma geçmeden önce işletim sisteminin tasarım dilini ve akıcılığını test etme imkânı sunar.
- Calamares gibi hantal, üçüncü parti ve impermanence/disko mimarisine yabancı yükleyicilerin karmaşası ve hata riski önlenir.
- Terminal tabanlı yerel sihirbaz hem hafif hem de hata durumunda tam şeffaflık ve hata ayıklama kolaylığı sağlar.

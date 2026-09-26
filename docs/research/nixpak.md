# Araştırma Notu: nixpak

- **Tarih:** 2026-09-26
- **Kaynak:** https://github.com/nixpak/nixpak
- **Durum:** Aktif, Bubblewrap (bwrap) tabanlı deklaratif uygulama kum havuzu (sandboxing).

## Genel Bakış ve Güncel Deseni
Flatpak'in arkasındaki Bubblewrap izolasyon teknolojisini Nix diliyle deklaratif hale getirir. Uygulamaların dosya sistemi, D-Bus, ağ ve ortam değişkeni erişimlerini sıkı kısıtlamalar altına alır.

## Güncel Kullanım Deseni
1. Flake girdisi:
   ```nix
   inputs.nixpak = {
     url = "github:nixpak/nixpak";
     inputs.nixpkgs.follows = "nixpkgs";
   };
   ```
2. Paket sarma (wrapping) örneği:
   ```nix
   let
     sandboxedApp = nixpak.lib.nixpak {
       inherit pkgs;
       config = { sloth, ... }: {
         app.package = pkgs.untrusted-tool;
         bubblewrap = {
           network = false; # Ağ erişimi yok
           bind.readOnly = [
             [ (sloth.concat' sloth.homeDir "/targets") "/targets" ]
           ];
           bind.dev = true;
         };
       };
     };
   in
     sandboxedApp.config.env
   ```
3. İleri Düzey Yetenekler:
   - `xdg-desktop-portal` entegrasyonu (dosya seçici portalları)
   - `pasta` ile ağ izolasyonu
   - `xdg-dbus-proxy` ile D-Bus filtreleme

## enyxma Açısından Değerlendirme
- Gray-hat güvenlik ortamında çalıştırılacak bilinmeyen exploitler, sızma testi betikleri, zararlı analiz araçları veya internet tarayıcılarının ana sistemden tam izolasyonu için en güçlü deklaratif araçtır.
- `modules/security/` katmanında doğrudan kullanılmalıdır.

# ROADMAP — enyxma

Her görev bitince ilgili kutuyu işaretle ve bir commit at. Yeni bir ajan/model devraldığında, işaretlenmemiş ilk maddeden devam eder.

## Faz 0 — Envanter, Araştırma ve İskelet

- [x] `docs/research/` altına disko, impermanence, nixos-generators, nixos-anywhere, nixos-hardware, lanzaboote, nixpak için güncel kullanım notları düşüldü (2026-09-26, linkli ve doğrulanmış).
- [x] `docs/research/quickshell-hyprland-lua.md` ile sıfırdan yekpare masaüstü mimarisi araştırıldı ve belgelendi.
- [x] Boş `flake.nix` iskeleti kuruldu ve doğrulandı.
- [x] `modules/`, `hosts/`, `shell/`, `docs/decisions/` klasörlerini oluştur, her birine 2-3 cümlelik `README.md` ile amacını yaz.

## Faz 1 — Sıfırdan Masaüstü ve Yekpare Tema Ekosistemi (`shell/`)

- [x] Sıfırdan modüler Pure Lua Hyprland (0.55+) mimarisini kur (`core/`, `wm/`, `ui/`).
- [x] Quickshell (QtQuick/QML) tabanlı egemen masaüstü kabuğunu inşa et (`TopBar`, `AppLauncher`, `ControlCenter`, `OSD`).
- [x] 4-5 seçkin temalı native tema motorunu (`Theme.qml` & IPC) kur (Stylix olmadan, anlık senkronizasyon).
- [x] `nixos-rebuild build-vm` veya doğrudan VM testi ile görsel ve fonksiyonel bütünlüğü doğrula.

## Faz 2 — Disk ve Impermanence Katmanı

- [x] `disko` ile deklaratif disk şeması yazıldı (tmpfs root, opsiyonel LUKS2, Btrfs subvolume'lar).
- [x] `impermanence` modülü entegre edildi (korunacak sistem ve kullanıcı durumları açıkça listelendi).
- [x] VM üzerinde disk formatlama/bağlama skriptleri ve sistem türetimi başarıyla doğrulandı.

## Faz 3 — Otomatik Donanım Uyumu

- [x] `nixos-hardware` ve `nixos-facter` stratejileri karşılaştırılarak ADR-0002 ve ADR-0006 yazıldı.
- [x] Cihaz bağımsız otomatik GPU (Mesa/RADV/VA-API/Nvidia/PRIME) ve çevre birimi modülü kuruldu.

## Faz 4 — Gray-Hat Güvenlik Katmanı (`modules/security/`)

- [x] İzole güvenlik araçları modülü kuruldu (kategorize profiller: network, recon, forensics, crypto, web).
- [x] `nixpak` ve Bubblewrap ile deklaratif sandbox (`enyxma-sandbox` tecrit kafesi) entegre edildi.
- [x] `lanzaboote` ile Secure Boot (UKI/sbctl) desteği ve impermanence PKI kalıcılığı yapılandırıldı.

## Faz 5 — Canlı ISO ve Prodüksiyon Kurulum Akışı

- [x] Yerel `nixpkgs` imaj motoru (`system.build.isoImage`) ile canlı ISO türetimini kur.
- [x] ISO açılışında 4-5 tema arasından seçim yapabilen, pro seviyede pürüzsüz kurulum akışını oluştur.
- [x] VM'e ve gerçek SSD'ye kurulumu uçtan uca test et.

## Faz 6 — Genişletme ve Belgelendirme

- [ ] Yeni tema varyasyonu eklemeyi sağlayan deklaratif arayüzü belgele.
- [ ] Kurulum, geliştirici ve güvenlik kullanım kılavuzlarını tamamla.

# ROADMAP — enyxma

Her görev bitince ilgili kutuyu işaretle ve bir commit at. Yeni bir ajan/model devraldığında, işaretlenmemiş ilk maddeden devam eder.

## Faz 0 — Envanter, Araştırma ve İskelet

- [x] `docs/research/` altına disko, impermanence, nixos-generators, nixos-anywhere, nixos-hardware, lanzaboote, nixpak için güncel kullanım notları düşüldü (2026-09-26, linkli ve doğrulanmış).
- [x] `docs/research/quickshell-hyprland-lua.md` ile sıfırdan yekpare masaüstü mimarisi araştırıldı ve belgelendi.
- [x] Boş `flake.nix` iskeleti kuruldu ve doğrulandı.
- [x] `modules/`, `hosts/`, `shell/`, `docs/decisions/` klasörlerini oluştur, her birine 2-3 cümlelik `README.md` ile amacını yaz.

## Faz 1 — Sıfırdan Masaüstü ve Yekpare Tema Ekosistemi (`shell/`)

- [ ] Sıfırdan modüler Pure Lua Hyprland (0.55+) mimarisini kur (`core/`, `wm/`, `ui/`).
- [ ] Quickshell (QtQuick/QML) tabanlı egemen masaüstü kabuğunu inşa et (`TopBar`, `AppLauncher`, `ControlCenter`, `OSD`).
- [ ] 4-5 seçkin temalı native tema motorunu (`Theme.qml` & IPC) kur (Stylix olmadan, anlık senkronizasyon).
- [ ] `nixos-rebuild build-vm` veya doğrudan VM testi ile görsel ve fonksiyonel bütünlüğü doğrula.

## Faz 2 — Disk ve Impermanence Katmanı

- [ ] `disko` ile deklaratif disk şeması yaz (tmpfs root, LUKS, Btrfs subvolume'lar).
- [ ] `impermanence` modülünü entegre et (korunacak yollar ve kullanıcı durumları açıkça listelenir).
- [ ] VM üzerinde reboot testiyle geçici kök dizinin temizlendiğini ve kalıcı yolların korunduğunu doğrula.

## Faz 3 — Otomatik Donanım Uyumu

- [ ] `nixos-hardware` ve `nixos-facter` stratejilerini karşılaştırarak bir ADR yaz.
- [ ] Cihaz bağımsız otomatik GPU (AMD/Intel/Nvidia) ve çevre birimi algılama/uyum modülünü kur.

## Faz 4 — Gray-Hat Güvenlik Katmanı (`modules/security/`)

- [ ] İzole güvenlik araçları modülünü kur (`modules/security/`).
- [ ] `nixpak` ile kritik/güvensiz uygulamaların (tarayıcılar, exploit araçları) deklaratif sandbox entegrasyonu.
- [ ] `lanzaboote` ile Secure Boot (UKI/sbctl) desteğini yapılandır.

## Faz 5 — Canlı ISO ve Prodüksiyon Kurulum Akışı

- [ ] Yerel `nixpkgs` imaj motoru (`system.build.isoImage`) ile canlı ISO türetimini kur.
- [ ] ISO açılışında 4-5 tema arasından seçim yapabilen, pro seviyede pürüzsüz kurulum akışını oluştur.
- [ ] VM'e ve gerçek SSD'ye kurulumu uçtan uca test et.

## Faz 6 — Genişletme ve Belgelendirme

- [ ] Yeni tema varyasyonu eklemeyi sağlayan deklaratif arayüzü belgele.
- [ ] Kurulum, geliştirici ve güvenlik kullanım kılavuzlarını tamamla.

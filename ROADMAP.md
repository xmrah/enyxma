# ROADMAP — enyxma

Her görev bitince ilgili kutuyu işaretle ve bir commit at. Yeni bir ajan/model devraldığında, işaretlenmemiş ilk maddeden devam eder.

## Faz 0 — Envanter ve iskelet

- [ ] Kullanıcının mevcut Quickshell + Hyprland + Lua dotfiles kurulumunun tam envanterini çıkar (hangi dosyalar, hangi config'ler, bağımlılıklar).
- [ ] `docs/research/` altına disko, impermanence, nixos-generators, nixos-anywhere, nixos-hardware, lanzaboote, nixpak için güncel kullanım notları düş (tarih + kaynak linki ile).
- [ ] Boş `flake.nix` iskeletini kur (tek bir `nixosConfigurations` girişi, gerçek donanım/disk bağlanmadan).
- [ ] `modules/`, `hosts/`, `shell/`, `docs/decisions/`, `docs/research/` klasörlerini oluştur, her birine 2-3 cümlelik `README.md` ile amacını yaz.

## Faz 1 — Mevcut dotfiles'ı declarative hale getir

- [ ] Mevcut Quickshell/Hyprland/Lua yapılandırmasını `shell/` altına, home-manager veya doğrudan NixOS modülü olarak taşı (hangisi seçildiyse ADR olarak kaydet).
- [ ] `nixos-rebuild build-vm` ile bir VM üzerinde bu haliyle doğrula.

## Faz 2 — Disk ve impermanence

- [ ] `disko` ile deklaratif disk şeması yaz (VM ve gerçek SSD için ayrı ayrı test edilebilir).
- [ ] `impermanence` modülünü entegre et (tmpfs/btrfs root, korunacak yollar açıkça listelenir).
- [ ] VM üzerinde reboot testiyle impermanence'ın gerçekten çalıştığını doğrula.

## Faz 3 — Otomatik donanım uyumu

- [ ] `nixos-hardware` ile bilinen donanım profillerini bağla.
- [ ] Bilinmeyen donanım için çalışma zamanı algılama/fallback stratejisini araştır ve ADR olarak yaz.

## Faz 4 — Gray-hat güvenlik katmanı

- [ ] `modules/security/` altında izole bir modül seti kur.
- [ ] `nixpak` ile uygulama sandbox'lama entegrasyonu.
- [ ] `lanzaboote` ile secure boot desteği.

## Faz 5 — Live ISO ve kurulum akışı

- [ ] `nixos-generators` ile live ISO üretimini kur.
- [ ] VM'e ve gerçek SSD'ye kurulum akışını uçtan uca test et.
- [ ] Kurulum sırasında tema/varyasyon seçimini (4-5 varyasyon) kurulum akışına entegre et.

## Faz 6 — Genişletme

- [ ] Yeni tema/varyasyon eklemeyi kolaylaştıran bir arayüz/convention belgele.
- [ ] Dokümantasyonu (kurulum kılavuzu, katkı kılavuzu) tamamla.
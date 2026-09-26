# Araştırma Notu: disko

- **Tarih:** 2026-09-26
- **Kaynak:** https://github.com/nix-community/disko
- **Durum:** Aktif, Nix ekosisteminde deklaratif disk yapılandırmasının fiili standardı.

## Genel Bakış ve Güncel Deseni
Disko, disk bölümlendirme, dosya sistemi formatlama ve bağlama (mount) işlemlerini Nix diliyle deklaratif olarak tanımlayan araçtır.

## Güncel Kullanım Deseni (Flake ile)
1. Flake girdisi:
   ```nix
   inputs.disko = {
     url = "github:nix-community/disko";
     inputs.nixpkgs.follows = "nixpkgs";
   };
   ```
2. NixOS modülü olarak entegrasyon:
   `disko.nixosModules.disko` sisteme dahil edilir.
3. Disk şeması (`disko.devices`):
   - GPT bölümleme
   - EFI System Partition (ESP)
   - LUKS şifreleme (`type = "luks"`)
   - Btrfs subvolume yönetimi (`@nix`, `@persist`, vb.)
   - tmpfs kök bağlama (`type = "tmpfs"`)
4. Komut satırı kullanımı:
   ```bash
   nix run github:nix-community/disko -- --mode destroy,format,mount /path/to/disko.nix
   ```

## enyxma Açısından Değerlendirme
- Projenin impermanence ve otomatik kurulum hedefleri için temel yapı taşıdır.
- Hem gerçek SSD hem de sanal makine (VM) için parametrik disk şeması yazımına uygundur.

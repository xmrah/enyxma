# Araştırma Notu: nixos-generators

- **Tarih:** 2026-09-26
- **Kaynak:** https://github.com/nix-community/nixos-generators
- **Durum:** **ARŞİVLENDİ / KULLANIM DIŞI (DEPRECATED)**
  - `nix-community/nixos-generators` deposu 30 Ocak 2026 tarihinde arşivlenerek salt-okunur (read-only) hale getirilmiştir.
  - Nedeni: İmaj üretme yetenekleri NixOS 25.05 ve sonrası itibarıyla doğrudan `nixpkgs` çekirdeğine (upstream) dahil edilmiştir.

## Güncel Kullanım Deseni ve Alternatifi
1. **Eski Yöntem (nixos-generators Flake):**
   Daha önce `nixos-generators.nixosModules.all-formats` veya `nixos-generators.nixosGenerate` kullanılıyordu. Artık bağımsız flake girdisi olarak kullanılması önerilmemektedir.
2. **Güncel Yerel Yöntem (Nixpkgs Native):**
   Canlı ISO ve imajlar doğrudan nixpkgs modülleriyle üretilir:
   ```nix
   # Canlı ISO türetimi
   iso = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     modules = [
       "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
       # veya minimal için installation-cd-minimal.nix
       ./configuration.nix
     ];
   };
   # Çıktı: config.system.build.isoImage
   ```

## enyxma Açısından Değerlendirme
- Dışarıdan `nixos-generators` flake girdisi çekmeye gerek yoktur; doğrudan `nixpkgs` içindeki yerel ISO modülleri (`system.build.isoImage`) kullanılmalıdır.
- Bu durum bağımlılık sayısını azaltır ve uzun vadeli stabilite sağlar.

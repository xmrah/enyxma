# Araştırma Notu: nixos-hardware

- **Tarih:** 2026-09-26
- **Kaynak:** https://github.com/NixOS/nixos-hardware
- **Durum:** Aktif, topluluk tabanlı donanım optimizasyon kütüphanesi.

## Genel Bakış ve Güncel Deseni
Farklı cihazların (Lenovo ThinkPad, Dell XPS, Framework, Apple Silicon vb.) ve donanım bileşenlerinin (Intel/AMD GPU, CPU mikrokodları, ses çipleri) bilinen sorunlarını ve kernel modüllerini önceden paketlenmiş modüller olarak sunar.

## Güncel Kullanım Deseni
1. Flake girdisi:
   ```nix
   inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
   ```
2. Modül importu:
   ```nix
   imports = [
     inputs.nixos-hardware.nixosModules.common-cpu-amd
     inputs.nixos-hardware.nixosModules.common-gpu-amd
     inputs.nixos-hardware.nixosModules.common-pc-ssd
   ];
   ```

## Önemli Alternatif: nixos-facter
- **Kaynak:** https://github.com/numtide/nixos-facter
- Çalışma zamanında cihazdaki tüm donanımı (PCI, USB, disk, CPU) tarayıp tek bir deklaratif JSON çıktısı üretir.
- Statik profil seçmek yerine, bilinmeyen cihazlarda otomatik donanım yapılandırması (`facter.json`) üretmek için modern bir alternatiftir.

## enyxma Açısından Değerlendirme
- "Her cihazda otomatik uyum" hedefi için statik cihaz modelleri yerine genel şemsiye modülleri (`common-cpu-*`, `common-gpu-*`) ve/veya dinamik `nixos-facter` stratejisi tercih edilmelidir.

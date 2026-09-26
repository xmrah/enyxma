# Araştırma Notu: lanzaboote

- **Tarih:** 2026-09-26
- **Kaynak:** https://github.com/nix-community/lanzaboote
- **Durum:** Aktif, NixOS için Secure Boot ve Measured Boot standart çözümü.

## Genel Bakış ve Güncel Deseni
NixOS sistemlerde UEFI Secure Boot desteğini deklaratif olarak sağlar. Geleneksel systemd-boot veya GRUB yerine, kernel ve initrd'yi imzalayıp Unified Kernel Image (UKI) veya imzalı stub mimarisiyle önyükleme zincirinin (Chain of Trust) kırılmasını önler.

## Güncel Kullanım Deseni
1. Flake girdisi:
   ```nix
   inputs.lanzaboote = {
     url = "github:nix-community/lanzaboote/v0.4.2";
     inputs.nixpkgs.follows = "nixpkgs";
   };
   ```
2. Modül yapılandırması:
   ```nix
   imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

   boot.loader.systemd-boot.enable = lib.mkForce false;

   boot.lanzaboote = {
     enable = true;
     pkiBundle = "/etc/secureboot";
   };

   environment.systemPackages = [ pkgs.sbctl ];
   ```
3. İmzalama anahtarlarının yönetimi `sbctl` CLI aracıyla yapılır.

## enyxma Açısından Değerlendirme
- Gray-hat güvenlik odaklı bir sistemde kernel tampering ve evil-maid saldırılarına karşı donanım seviyesinde zorunlu bir koruma kalkanıdır.
- Canlı kurulum aşamasında TPM2 ve Secure Boot anahtar kaydı adım adım entegre edilebilir.

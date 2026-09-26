# Araştırma Notu: impermanence

- **Tarih:** 2026-09-26
- **Kaynak:** https://github.com/nix-community/impermanence
- **Durum:** Aktif, geçici kök (ephemeral/tmpfs/btrfs root) sistemler için standart modül.

## Genel Bakış ve Güncel Deseni
Sistemin kök dizinini (`/`) her açılışta sıfırlanacak şekilde RAM'de (`tmpfs`) veya boş bir Btrfs snapshot'ında tutarken, yalnızca kalıcı olması gereken dosya ve dizinleri (`/persist` gibi) bildiren modüldür.

## Güncel Kullanım Deseni
1. Flake girdisi:
   ```nix
   inputs.impermanence.url = "github:nix-community/impermanence";
   ```
2. Modül tanımlaması:
   ```nix
   imports = [ inputs.impermanence.nixosModules.impermanence ];

   environment.persistence."/persist" = {
     hideMounts = true;
     directories = [
       "/var/log"
       "/var/lib/nixos"
       "/var/lib/systemd/coredump"
       "/etc/NetworkManager/system-connections"
     ];
     files = [
       "/etc/machine-id"
     ];
     users.enyxma = {
       directories = [
         "Downloads"
         "Music"
         "Pictures"
         "Documents"
         "Videos"
         ".local/share/keyrings"
         ".ssh"
       ];
       files = [ ];
     };
   };
   ```
3. Kök dizin tmpfs bağlaması:
   ```nix
   fileSystems."/" = {
     device = "none";
     fsType = "tmpfs";
     options = [ "defaults" "size=8G" "mode=755" ];
   };
   ```

## enyxma Açısından Değerlendirme
- Gray-hat güvenlik felsefesinde sistemin iz bırakmaması ve kirlenmemesi için çekirdek bileşendir.
- Home Manager entegrasyonu da mevcuttur.

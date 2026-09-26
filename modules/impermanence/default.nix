{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.enyxma.impermanence;

  # Her belirtilen kullanıcı için standart kalıcı dizin ve dosya şablonu
  mkUserPersistence = username: {
    directories = [
      "Downloads"
      "Documents"
      "Pictures"
      "Music"
      "Videos"
      "Projects"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".cache/nix"
    ];
    files = [
      ".bash_history"
    ];
  };
in
{
  options.enyxma.impermanence = {
    enable = mkEnableOption "enyxma deklaratif impermanence (ephemeral root) mimarisi";

    persistPath = mkOption {
      type = types.str;
      default = "/persist";
      description = "Kalıcı durumların saklandığı ana bağlama noktası";
    };

    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Kalıcı ev dizini alanları oluşturulacak kullanıcı adları listesi";
    };
  };

  config = mkIf cfg.enable {
    # /persist bağlama noktasının sistem açılışında erken hazır olması zorunludur
    fileSystems.${cfg.persistPath}.neededForBoot = true;

    # Impermanence deklarasyonu
    environment.persistence.${cfg.persistPath} = {
      hideMounts = true;

      # Sistem genelinde korunacak kritik dizinler
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/pipewire"
      ];

      # Sistem genelinde korunacak kritik dosyalar
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];

      # Kullanıcı düzeyinde durum kalıcılığı
      users = genAttrs cfg.users mkUserPersistence;
    };

    # /persist dizini güvenlik izinleri (Root 0700 veya 0755)
    systemd.tmpfiles.rules = [
      "d ${cfg.persistPath} 0755 root root -"
      "d ${cfg.persistPath}/var 0755 root root -"
      "d ${cfg.persistPath}/var/log 0755 root root -"
      "d ${cfg.persistPath}/etc 0755 root root -"
      "d ${cfg.persistPath}/etc/ssh 0700 root root -"
    ];
  };
}

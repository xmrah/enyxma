{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.enyxma.security.secureboot;
in
{
  options.enyxma.security.secureboot = {
    enable = mkEnableOption "lanzaboote ile UEFI Secure Boot ve UKI desteği";

    pkiBundle = mkOption {
      type = types.str;
      default = "/etc/secureboot";
      description = "Secure boot PKI anahtarları ve veritabanı dizini";
    };
  };

  config = mkIf cfg.enable {
    # Lanzaboote etkinleştirildiğinde standart systemd-boot devre dışı bırakılır
    boot.loader.systemd-boot.enable = mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = cfg.pkiBundle;
    };

    environment.systemPackages = [
      pkgs.sbctl
    ];

    # Secure Boot PKI anahtarlarının impermanence ortamında korunmasını garanti et
    environment.persistence."/persist" = mkIf (config.enyxma.impermanence.enable or false) {
      directories = [
        cfg.pkiBundle
      ];
    };
  };
}

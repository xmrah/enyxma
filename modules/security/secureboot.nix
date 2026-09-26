{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.enyxma.security.secureboot;
  hasPersistence = options ? environment && options.environment ? persistence;
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

  config = mkMerge [
    (mkIf cfg.enable {
      # Lanzaboote etkinleştirildiğinde standart systemd-boot devre dışı bırakılır
      boot.loader.systemd-boot.enable = mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = cfg.pkiBundle;
      };

      environment.systemPackages = [
        pkgs.sbctl
      ];
    })
    (optionalAttrs hasPersistence {
      environment.persistence."/persist" = mkIf (cfg.enable && (config.enyxma.impermanence.enable or false)) {
        directories = [
          cfg.pkiBundle
        ];
      };
    })
  ];
}

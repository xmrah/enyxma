{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.enyxma.installer;

  # Hedef sisteme aktarılacak modül ve kabuk şablonu
  enyxmaTemplate = pkgs.runCommand "enyxma-template" { } ''
    mkdir -p $out
    cp -r ${../../modules} $out/modules
    cp -r ${../../shell} $out/shell
  '';

  # Installer betiğini şablon yoluyla birlikte paketle
  enyxmaInstallPkg = pkgs.writeShellScriptBin "enyxma-install" ''
    export ENYXMA_TEMPLATE="${enyxmaTemplate}"
    ${builtins.readFile ./enyxma-install.sh}
  '';
in
{
  options.enyxma.installer = {
    enable = mkEnableOption "enyxma interaktif sistem kurulum sihirbazı";

    autoLaunch = mkOption {
      type = types.bool;
      default = false;
      description = "Canlı oturum masaüstü açılışında kurulum sihirbazını otomatik başlat";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      enyxmaInstallPkg
      pkgs.whois # mkpasswd için
      pkgs.parted
      pkgs.util-linux
    ];

    # Canlı oturumda otomatik başlatıcı
    systemd.user.services.enyxma-installer-autostart = mkIf cfg.autoLaunch {
      description = "enyxma Installer Autostart";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.kitty}/bin/kitty --title 'enyxma installer' ${enyxmaInstallPkg}/bin/enyxma-install";
        Restart = "no";
      };
    };
  };
}

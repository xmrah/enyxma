{ config, lib, options, ... }:

with lib;

let
  hwCfg = config.enyxma.hardware;
  facterCfg = hwCfg.facter;
  hasFacter = options ? facter;
in
{
  options.enyxma.hardware.facter = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "nixos-facter donanım raporu ile otomatik donanım yapılandırması";
    };

    reportPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Cihazda oluşturulan facter.json dosyasının yolu";
    };
  };

  config = optionalAttrs hasFacter (mkIf (hwCfg.enable && facterCfg.enable && facterCfg.reportPath != null) {
    facter.reportPath = facterCfg.reportPath;
  });
}

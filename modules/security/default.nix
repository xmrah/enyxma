{ config, lib, ... }:

with lib;

let
  cfg = config.enyxma.security;
in
{
  imports = [
    ./tools.nix
    ./sandbox.nix
    ./secureboot.nix
  ];

  options.enyxma.security = {
    enable = mkEnableOption "enyxma gray-hat siber güvenlik, sandbox ve önyükleme güvenliği katmanı";
  };

  config = mkIf cfg.enable {
    # Güvenlik katmanı açıldığında varsayılan olarak temel araç seti ve sandbox devreye girer
    enyxma.security.tools.enable = mkDefault true;
    enyxma.security.sandbox.enable = mkDefault true;
  };
}

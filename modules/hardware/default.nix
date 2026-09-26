{ config, lib, ... }:

with lib;

{
  imports = [
    ./gpu.nix
    ./peripherals.nix
    ./facter.nix
  ];

  options.enyxma.hardware = {
    enable = mkEnableOption "enyxma evrensel otomatik donanım ve çevre birimi uyumu katmanı";
  };
}

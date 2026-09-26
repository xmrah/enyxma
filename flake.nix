{
  description = "enyxma — Gray-hat siber güvenlik ve geliştirici odaklı egemen sistem";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      enyxma = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.hostPlatform = system;
            system.stateVersion = "26.05";

            # İskelet: Gerçek donanım ve disk şeması sonraki fazlarda bağlanacak
            fileSystems."/" = {
              device = "none";
              fsType = "tmpfs";
            };
            boot.loader.systemd-boot.enable = true;
          }
        ];
      };
    };
  };
}

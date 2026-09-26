{
  description = "enyxma — Gray-hat siber güvenlik ve geliştirici odaklı egemen sistem";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Dışa aktarılan deklaratif modüller
    nixosModules = {
      desktop = import ./modules/desktop;
      homeManager = (import ./shell { inherit (pkgs) lib; inherit pkgs; }).homeManagerModule;
    };

    nixosConfigurations = {
      enyxma = nixpkgs.lib.nixosSystem {
        modules = [
          self.nixosModules.desktop
          {
            nixpkgs.hostPlatform = system;
            system.stateVersion = "26.05";

            # İskelet kök dosya sistemi (tmpfs)
            fileSystems."/" = {
              device = "none";
              fsType = "tmpfs";
            };
            boot.loader.systemd-boot.enable = true;

            # Masaüstü ve Tema Ekosistemini Etkinleştir
            enyxma.desktop = {
              enable = true;
              defaultTheme = "void-black";
            };

            # VM Doğrulama ve Test Yapılandırması
            virtualisation.vmVariant = {
              virtualisation = {
                memorySize = 4096;
                cores = 4;
              };
            };
          }
        ];
      };
    };
  };
}

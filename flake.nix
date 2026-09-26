{
  description = "enyxma — Gray-hat siber güvenlik ve geliştirici odaklı egemen sistem";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  outputs = { self, nixpkgs, disko, impermanence, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Dışa aktarılan deklaratif modüller
    nixosModules = {
      desktop = import ./modules/desktop;
      disko = import ./modules/disko;
      impermanence = import ./modules/impermanence;
      homeManager = (import ./shell { inherit (pkgs) lib; inherit pkgs; }).homeManagerModule;
    };

    nixosConfigurations = {
      enyxma = nixpkgs.lib.nixosSystem {
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          self.nixosModules.desktop
          self.nixosModules.disko
          self.nixosModules.impermanence
          {
            nixpkgs.hostPlatform = system;
            system.stateVersion = "26.05";

            # Disko & Impermanence Yapılandırması (Faz 2)
            enyxma.disko = {
              enable = true;
              device = "/dev/vda";
              encrypted = false; # VM için şifresiz, prodüksiyon SSD için true
              tmpfsSize = "8G";
            };

            # Standart Operatör Kullanıcısı
            users.users.enyxma = {
              isNormalUser = true;
              extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
              description = "enyxma operator";
            };

            enyxma.impermanence = {
              enable = true;
              persistPath = "/persist";
              users = [ "enyxma" ];
            };

            boot.loader.systemd-boot.enable = true;

            # Masaüstü ve Tema Ekosistemini Etkinleştir (Faz 1)
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

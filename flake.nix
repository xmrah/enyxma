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

    nixos-facter-modules = {
      url = "github:nix-community/nixos-facter-modules";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
  };

  outputs = { self, nixpkgs, disko, impermanence, nixos-facter-modules, nixos-hardware, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Dışa aktarılan deklaratif modüller
    nixosModules = {
      desktop = import ./modules/desktop;
      disko = import ./modules/disko;
      impermanence = import ./modules/impermanence;
      hardware = import ./modules/hardware;
      homeManager = (import ./shell { inherit (pkgs) lib; inherit pkgs; }).homeManagerModule;
    };

    nixosConfigurations = {
      enyxma = nixpkgs.lib.nixosSystem {
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          nixos-facter-modules.nixosModules.facter
          self.nixosModules.desktop
          self.nixosModules.disko
          self.nixosModules.impermanence
          self.nixosModules.hardware
          {
            nixpkgs.hostPlatform = system;
            system.stateVersion = "26.05";

            # Donanım ve GPU Uyumu (Faz 3)
            enyxma.hardware = {
              enable = true;
              gpu.driver = "auto"; # Evrensel Mesa/RADV/Intel hızlandırması
            };

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

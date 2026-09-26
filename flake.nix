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

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, impermanence, nixos-facter-modules, nixos-hardware, lanzaboote, nixpak, ... }@inputs:
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
      security = import ./modules/security;
      installer = import ./modules/installer;
      homeManager = (import ./shell { inherit (pkgs) lib; inherit pkgs; }).homeManagerModule;
    };

    # Nixpak kütüphanesini dışa aktar
    lib = {
      nixpak = nixpak.lib.nixpak { inherit (pkgs) lib pkgs; };
    };

    # Doğrudan derlenebilir paketler
    packages.${system} = {
      # Canlı ISO İmajı: `nix build .#iso`
      iso = self.nixosConfigurations.iso.config.system.build.isoImage;
      # VM Çıktısı: `nix build .#vm`
      vm = self.nixosConfigurations.enyxma.config.system.build.vm;
    };

    apps.${system} = {
      # Doğrudan VM çalıştırma: `nix run .#vm`
      vm = {
        type = "app";
        program = "${self.nixosConfigurations.enyxma.config.system.build.vm}/bin/run-enyxma-vm";
      };
      default = self.apps.${system}.vm;
    };

    nixosConfigurations = {
      # 1. Kurulu Hedef Sistem Yapılandırması (SSD / VM)
      enyxma = nixpkgs.lib.nixosSystem {
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          nixos-facter-modules.nixosModules.facter
          lanzaboote.nixosModules.lanzaboote
          self.nixosModules.desktop
          self.nixosModules.disko
          self.nixosModules.impermanence
          self.nixosModules.hardware
          self.nixosModules.security
          self.nixosModules.installer
          {
            nixpkgs.hostPlatform = system;
            system.stateVersion = "26.05";

            # Gray-Hat Güvenlik ve İzolasyon Katmanı (Faz 4)
            enyxma.security = {
              enable = true;
              tools = {
                enable = true;
                categories = [ "all" ];
              };
              sandbox.enable = true;
              secureboot.enable = false; # VM için false, donanım kurulumunda true
            };

            # Donanım ve GPU Uyumu (Faz 3)
            enyxma.hardware = {
              enable = true;
              gpu.driver = "auto";
            };

            # Disko & Impermanence Yapılandırması (Faz 2)
            enyxma.disko = {
              enable = true;
              device = "/dev/vda";
              encrypted = false;
              tmpfsSize = "8G";
            };

            # Standart Operatör Kullanıcısı
            users.users.enyxma = {
              isNormalUser = true;
              extraGroups = [ "wheel" "video" "audio" "networkmanager" "wireshark" ];
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

            # Kurulum Aracı
            enyxma.installer.enable = true;

            # VM Doğrulama ve Test Yapılandırması
            virtualisation.vmVariant = {
              virtualisation = {
                memorySize = 4096;
                cores = 4;
                qemu.options = [
                  "-vga none"
                  "-device virtio-gpu-pci"
                ];
              };
              users.users.enyxma.initialHashedPassword = "";
              security.sudo.wheelNeedsPassword = false;
              services.greetd.settings.initial_session = {
                command = "Hyprland";
                user = "enyxma";
              };
            };
          }
        ];
      };

      # 2. Canlı Kurulum ISO Yapılandırması (Faz 5)
      iso = nixpkgs.lib.nixosSystem {
        modules = [
          lanzaboote.nixosModules.lanzaboote
          self.nixosModules.desktop
          self.nixosModules.hardware
          self.nixosModules.security
          self.nixosModules.installer
          ./hosts/iso
        ];
      };
    };
  };
}

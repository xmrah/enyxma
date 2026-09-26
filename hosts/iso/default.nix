{ config, lib, pkgs, modulesPath, ... }:

with lib;

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";

  # ISO İmaj İsmi ve Sıkıştırma (ADR-0001 Native Nixpkgs İmaj Motoru)
  image.baseName = mkForce "enyxma";
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";

  # Canlı Masaüstü ve Tema Ekosistemi (Faz 1)
  enyxma.desktop = {
    enable = true;
    defaultTheme = "void-black";
  };

  # Evrensel Donanım ve GPU Hızlandırması (Faz 3)
  enyxma.hardware = {
    enable = true;
    gpu.driver = "auto";
  };

  # Canlı Oturum Güvenlik Araçları (Faz 4)
  enyxma.security = {
    enable = true;
    tools.enable = true;
    tools.categories = [ "all" ];
    sandbox.enable = true;
    secureboot.enable = false;
  };

  # İnteraktif Kurulum Sihirbazı (Otomatik başlatma aktif)
  enyxma.installer = {
    enable = true;
    autoLaunch = true;
  };

  # Canlı Kullanıcı: 'nixos' (Şifresiz sudo ve Hyprland otomatik açılış)
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "wireshark" ];
    description = "enyxma live user";
  };
  security.sudo.wheelNeedsPassword = false;

  # Canlı Oturum Otomatik Açılış (Doğrudan Hyprland)
  services.greetd.settings.initial_session = {
    command = "Hyprland";
    user = "nixos";
  };

  # Ağ Yönetimi (Live Wi-Fi ve Ethernet)
  networking.networkmanager.enable = true;
  networking.wireless.enable = mkForce false;
  boot.zfs.forceImportRoot = false;
}

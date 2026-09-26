{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.enyxma.security.tools;

  hasCategory = cat: elem "all" cfg.categories || elem cat cfg.categories;

  categoryPackages = {
    network = with pkgs; [
      nmap
      tshark
      tcpdump
      socat
      netcat
      iperf3
    ];

    recon = with pkgs; [
      dnsutils
      whois
      traceroute
      masscan
    ];

    forensics = with pkgs; [
      binwalk
      radare2
      hexyl
    ];

    crypto = with pkgs; [
      age
      sops
      gnupg
      openssl
      yubikey-manager
    ];

    web = with pkgs; [
      curl
      wget
      mitmproxy
    ];
  };

  selectedPackages = flatten [
    (optional (hasCategory "network") categoryPackages.network)
    (optional (hasCategory "recon") categoryPackages.recon)
    (optional (hasCategory "forensics") categoryPackages.forensics)
    (optional (hasCategory "crypto") categoryPackages.crypto)
    (optional (hasCategory "web") categoryPackages.web)
    cfg.extraPackages
  ];
in
{
  options.enyxma.security.tools = {
    enable = mkEnableOption "enyxma siber güvenlik ve analiz araçları seti";

    categories = mkOption {
      type = types.listOf (types.enum [
        "all"
        "network"
        "recon"
        "forensics"
        "crypto"
        "web"
      ]);
      default = [ "network" "recon" "crypto" ];
      description = "Sisteme dahil edilecek güvenlik araç kategorileri";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Kullanıcı tanımlı ek güvenlik araçları";
    };
  };

  config = mkIf cfg.enable {
    # Seçilen kategorilere ait araçları sisteme yükle
    environment.systemPackages = selectedPackages;

    # Wireshark / TShark ağ paket yakalama yetkileri
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark-cli;
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.enyxma.desktop;
  themes = import ./../../shell/themes { inherit lib pkgs; };
in
{
  options.enyxma.desktop = {
    enable = mkEnableOption "enyxma Quickshell + Hyprland Pure Lua masaüstü ekosistemi";

    defaultTheme = mkOption {
      type = types.enum [
        "void-black"
        "cyber-matrix"
        "ghost-white"
        "slate-cobalt"
        "blood-amber"
      ];
      default = "void-black";
      description = "Sistem açılışındaki varsayılan tema varyasyonu";
    };
  };

  config = mkIf cfg.enable {
    # 1. Hyprland ve UWSM Oturum Yöneticisi
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # 2. XDG ve Portallar (Wayland ekran paylaşımı ve bildirimler)
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    # 3. Masaüstü ve Kabuk Paketleri
    environment.systemPackages = with pkgs; [
      quickshell
      kitty
      wl-clipboard
      cliphist
      grim
      slurp
      brightnessctl
      playerctl
      libnotify
      wireplumber
    ];

    # 4. Yazı Tipleri (Arayüz ve Monospace Uçbirim)
    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
      ];
      fontconfig.defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
      };
    };

    # 5. Sistem Genelinde XDG Yapılandırmaları (/etc/xdg)
    # Canlı ISO veya impermanence ortamında hiçbir ev dizini kopyalamasına ihtiyaç duymadan çalışır
    environment.etc = {
      "xdg/hypr".source = ./../../shell/hypr;
      "xdg/quickshell".source = ./../../shell/quickshell;
      "enyxma/palettes.json".source = ./../../shell/themes/palettes.json;
      "xdg/kitty/kitty.conf".text = themes.toKittyConf cfg.defaultTheme;
    };

    # 6. Ortam Değişkenleri
    environment.variables = {
      HYPRLAND_CONFIG = "/etc/xdg/hypr/hyprland.lua";
      QS_CONFIG_PATH = "/etc/xdg/quickshell/shell.qml";
    };

    # 7. Quickshell Systemd Kullanıcı Servisi
    systemd.user.services.quickshell = {
      description = "enyxma Quickshell Masaüstü Kabuğu";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.quickshell}/bin/quickshell -p /etc/xdg/quickshell/shell.qml";
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}

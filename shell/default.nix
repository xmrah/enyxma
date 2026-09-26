{ lib, pkgs }:

let
  themes = import ./themes { inherit lib pkgs; };
in
{
  inherit themes;

  hyprPath = ./hypr;
  quickshellPath = ./quickshell;

  # Opsiyonel Home-Manager Modülü (ADR-0004 Hibrit Model)
  homeManagerModule = { config, lib, pkgs, ... }: {
    xdg.configFile."hypr".source = ./hypr;
    xdg.configFile."quickshell".source = ./quickshell;
    home.packages = with pkgs; [
      quickshell
      kitty
      wl-clipboard
      cliphist
      grim
      slurp
      brightnessctl
      playerctl
      libnotify
    ];
  };
}

{ lib, pkgs }:

let
  palettes = import ./palettes.nix { inherit lib; };
  palettesJson = pkgs.writeText "enyxma-palettes.json" (builtins.toJSON palettes);
in
{
  inherit palettes palettesJson;

  # Kitty terminal tema formatına dönüştürücü
  toKittyConf = themeName:
    let
      theme = palettes.${themeName} or palettes.void-black;
      c = theme.colors;
    in
    ''
      # enyxma :: ${theme.name} Theme
      background ${c.background}
      foreground ${c.text}
      selection_background ${c.accent}
      selection_foreground ${c.background}
      cursor ${c.accent}
      cursor_text_color ${c.background}

      active_border_color ${c.accent}
      inactive_border_color ${c.border}

      # Black
      color0 ${c.background}
      color8 ${c.surfaceHover}
      # Red
      color1 ${c.danger}
      color9 ${c.danger}
      # Green
      color2 ${c.success}
      color10 ${c.success}
      # Yellow
      color3 ${c.warning}
      color11 ${c.warning}
      # Blue
      color4 ${c.secondary}
      color12 ${c.secondary}
      # Magenta
      color5 ${c.accent}
      color13 ${c.accent}
      # Cyan
      color6 ${c.accent}
      color14 ${c.accent}
      # White
      color7 ${c.text}
      color15 ${c.text}
    '';
}

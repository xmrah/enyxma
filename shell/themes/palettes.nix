# enyxma :: Declarative Theme Palettes (Single Source of Truth)
{ lib }:

{
  void-black = {
    name = "Void Black";
    description = "Minimalist saf siyah, derin kömür ve neon cam göbeği vurgusu";
    isDark = true;
    colors = {
      background   = "#0a0a0c";
      surface      = "#131318";
      surfaceHover = "#1c1c24";
      border       = "#262633";
      accent       = "#00e5ff";
      accentHover  = "#33edff";
      secondary    = "#7aa2f7";
      text         = "#e0e6ed";
      textMuted    = "#79828c";
      danger       = "#ff5555";
      success      = "#50fa7b";
      warning      = "#f1fa8c";
    };
    hyprland = {
      activeBorderColors = [ "rgba(00e5ffee)" "rgba(262633ee)" ];
      inactiveBorderColor = "rgba(101014aa)";
    };
  };

  cyber-matrix = {
    name = "Cyber Matrix";
    description = "Siber güvenlik estetiği, koyu zümrüt yeşili ve parlak matrix neonu";
    isDark = true;
    colors = {
      background   = "#050c08";
      surface      = "#0b1710";
      surfaceHover = "#12261b";
      border       = "#1b3827";
      accent       = "#00ff66";
      accentHover  = "#33ff85";
      secondary    = "#00e5a3";
      text         = "#dcf5e3";
      textMuted    = "#5c8a6b";
      danger       = "#ff4444";
      success      = "#00ff66";
      warning      = "#ffcc00";
    };
    hyprland = {
      activeBorderColors = [ "rgba(00ff66ee)" "rgba(1b3827ee)" ];
      inactiveBorderColor = "rgba(050c08aa)";
    };
  };

  ghost-white = {
    name = "Ghost White";
    description = "Yüksek kontrastlı, kristal beyaz ve teknik safir mavisi";
    isDark = false;
    colors = {
      background   = "#f5f7fa";
      surface      = "#ffffff";
      surfaceHover = "#ebf0f5";
      border       = "#d5dbe3";
      accent       = "#0052cc";
      accentHover  = "#0065ff";
      secondary    = "#2684ff";
      text         = "#172b4d";
      textMuted    = "#6b778c";
      danger       = "#de350b";
      success      = "#36b37e";
      warning      = "#ffab00";
    };
    hyprland = {
      activeBorderColors = [ "rgba(0052ccee)" "rgba(d5dbe3ee)" ];
      inactiveBorderColor = "rgba(ebf0f5aa)";
    };
  };

  slate-cobalt = {
    name = "Slate Cobalt";
    description = "Teknik mühendislik mavisi, soğuk antrasit ve kobalt ışıltısı";
    isDark = true;
    colors = {
      background   = "#0d131a";
      surface      = "#151e29";
      surfaceHover = "#1d2a3a";
      border       = "#283b52";
      accent       = "#2d7ff9";
      accentHover  = "#579aff";
      secondary    = "#60a5fa";
      text         = "#e2e8f0";
      textMuted    = "#8092a8";
      danger       = "#ef4444";
      success      = "#10b981";
      warning      = "#f59e0b";
    };
    hyprland = {
      activeBorderColors = [ "rgba(2d7ff9ee)" "rgba(283b52ee)" ];
      inactiveBorderColor = "rgba(0d131aaa)";
    };
  };

  blood-amber = {
    name = "Blood Amber";
    description = "Karanlık obsidyen, kızıl kehribar ve alev turuncusu";
    isDark = true;
    colors = {
      background   = "#100808";
      surface      = "#1a0f0f";
      surfaceHover = "#261515";
      border       = "#3b2020";
      accent       = "#ff4d00";
      accentHover  = "#ff7033";
      secondary    = "#ff8533";
      text         = "#fce8e6";
      textMuted    = "#8f6e6d";
      danger       = "#ff2200";
      success      = "#4ade80";
      warning      = "#facc15";
    };
    hyprland = {
      activeBorderColors = [ "rgba(ff4d00ee)" "rgba(3b2020ee)" ];
      inactiveBorderColor = "rgba(100808aa)";
    };
  };
}

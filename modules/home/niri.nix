{ inputs, ... }: {
  flake.homeModules.niri = { pkgs, ... }: {
    # Config niri w Nixie - walidowany w build time
    programs.niri.settings = {
      input = {
        keyboard.xkb.layout = "pl";
        touchpad = {
          tap = true;
          natural-scroll = true;
          dwt = true;  # disable-while-typing
        };
        mouse.accel-profile = "flat";
      };

      # Auto-start ekosystemu (bar, notyfikacje, wallpaper)
      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "mako" ]; }
        { command = [ "xwayland-satellite" ]; }
      ];

      # Podstawowe bindy - reszta defaultowo z niri
      binds = {
        "Mod+Return".action.spawn = "ghostty";
        "Mod+D".action.spawn = "fuzzel";
        "Mod+Shift+E".action.quit = [];
        "Mod+Q".action.close-window = [];
        # reszta bindów defaultowa - niri ma sensowne domyślne
      };

      layout = {
        gaps = 8;
        border = {
          enable = true;
          width = 2;
        };
      };
    };

    # Ekosystem - paczki + config
    home.packages = with pkgs; [
      fuzzel              # launcher
      mako                # daemon notyfikacji
      swaylock            # lockscreen
      swayidle            # idle detector
      awww                # wallpaper
      wl-clipboard        # clipboard CLI
      grim                # screenshot
      slurp               # region selector
      brightnessctl       # jasność (zwłaszcza laptop)
      playerctl           # media keys
    ];

    # Waybar - minimalny config, rozbuduj później
    programs.waybar = {
      enable = true;
      systemd.enable = false;  # niri sam odpala przez spawn-at-startup
    };
  };
}

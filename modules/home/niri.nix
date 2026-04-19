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
        # spawn apps
        "Mod+Return".action.spawn = "ghostty";
        "Mod+D".action.spawn = "fuzzel";

	# quit window
	"Mod+Q".action.close-window = [];

	# exit
        "Mod+Shift+E".action.quit = [];

        "Mod+H".action.focus-column-left = {};
        "Mod+L".action.focus-column-right = {};
  
        "Mod+Shift+H".action.move-column-left = {};
        "Mod+Shift+L".action.move-column-right = {};
  
        "Mod+Shift+PageDown".action.move-column-to-workspace-down = {};
        "Mod+Shift+PageUp".action.move-column-to-workspace-up = {};
  
        "Mod+PageDown".action.switch-workspace-down = {};
        "Mod+PageUp".action.switch-workspace-up = {};
  
        "Mod+R".action.switch-preset-column-widths = {};
        "Mod+M".action.maximize-column = {};
  
        "Mod+Comma".action.consume-or-expel-window-left = {};
        "Mod+Period".action.consume-or-expel-window-right = {};
  
        "Mod+V".action.toggle-window-floating = {};
        "Mod+F".action.toggle-focus-follows-mouse = {};
  
        "Mod+Slash".action.show-hotkey-overlay = {};
        "Mod+O".action.toggle-overview = {};
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

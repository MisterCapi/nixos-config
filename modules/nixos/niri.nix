{ inputs, ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    imports = [ inputs.niri.nixosModules.niri ];

    programs.niri.package = pkgs.niri;
    programs.niri.enable = true;

    # Login menedżer - zostawiamy SDDM (już masz), niri-session pojawi się automatycznie
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;  # ważne dla niri
    };

    # xwayland-satellite - żeby X11 apki działały
    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    # Portals - niri-flake to robi automatycznie przez programs.niri.enable,
    # ale dodatkowo warto mieć GTK portal dla file pickerów bez Nautilus-a
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "gtk";
    };
  };
}

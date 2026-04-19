{ ... }:
{
  flake.nixosModules.plasma = {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.xserver.xkb.layout = "pl";
  };
}

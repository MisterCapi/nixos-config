{ ... }:
{
  flake.homeModules.telegram-desktop = { pkgs, ... }: {
    home.packages = [ pkgs.telegram-desktop ];
  };
}

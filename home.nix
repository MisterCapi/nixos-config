{ pkgs, ... }:

{
  home.username = "mrcapi";
  home.homeDirectory = "/home/mrcapi";
  home.stateVersion = "26.05";

  programs.plasma = {
    enable = true;

    kwinrc = {
      "Effect-shakecursor"."Enabled" = false;
      "ElectricBorders" = {
        "EdgeBarrier" = 0;
        "CornerBarrier" = false;
      };
    };
  };
}

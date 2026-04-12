{ pkgs, ... }:

{
  home.username = "mrcapi";
  home.homeDirectory = "/home/mrcapi";
  home.stateVersion = "26.05";

  programs.plasma = {
    enable = true;

    input.keyboard.numlockOnStartup = "on";

    kwin = {
      effects.shakeCursor.enable = false;
      edgeBarrier = 0;
      cornerBarrier = false;
    };
  };
}

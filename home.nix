{ pkgs, ... }:

let
  username = "mrcapi";
  os_version = "26.05";
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = os_version;

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

{ ... }:
{
  flake.homeModules.plasma = {
    programs.plasma = {
      enable = true;
      input.keyboard.numlockOnStartup = "on";
      kwin = {
        effects.shakeCursor.enable = false;
        edgeBarrier = 0;
        cornerBarrier = false;
      };
    };
  };
}

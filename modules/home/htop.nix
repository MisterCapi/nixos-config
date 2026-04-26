{ ... }:
{
  flake.modeModules.htop = {
    programs.htop = {
      enable = true;
    };
  };
}

{ ... }:
{
  flake.homeModules.htop = {
    programs.htop = {
      enable = true;
    };
  };
}

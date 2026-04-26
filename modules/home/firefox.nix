{ ... }:
{
  flake.homeModules.firefox = {
    programs.firefox = {
      enable = true;
      # A lot of settings to setup here
      profiles.default.settings = {
      
      };
    };
  };
}

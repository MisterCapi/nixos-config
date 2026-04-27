{ ... }:
{
  flake.homeModules.firefox = {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {};
      };
      # Needs more settings here like personal and work profiles etc
      # look at https://gitlab.com/ny-nix-config-group/nynixosconfig/-/blob/main/homeManagerModules/programs/gui/firefox.nix
    };
    stylix.targets.firefox.profileNames = [ "default" ];
  };
}

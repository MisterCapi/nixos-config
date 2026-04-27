{ ... }:
{
  flake.homeModules.librewolf = {
    programs.librewolf = {
      enable = true;
      profiles = {
        my-profile = {
          # bookmarks, extensions, search engines...
        };
        my-friends-profile = {
          # bookmarks, extensions, search engines...
        };
      };
    };

    stylix.targets.firefox.profileNames = [ "my-profile" "my-friends-profile" ];
  };
}

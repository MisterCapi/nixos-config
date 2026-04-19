{ self, ... }:
{
  flake.nixosModules.base = { config, pkgs, ... }: {
    imports = [ self.nixosModules.meta ];   # żeby config.my.* działał
                                            # (zarejestrowane przez meta.nix przez flake.modules)

    time.timeZone = "Europe/Warsaw";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "pl2";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    # Cache dla Niri żeby nie rekompilować lokalnie
    nix.settings = {
      substituters = [ "https://niri.cachix.org" ];
      trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
    };

    system.stateVersion = config.my.stateVersion;
  };
}

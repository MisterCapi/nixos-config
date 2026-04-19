{ self, ... }:
{
  flake.nixosModules.base = { config, pkgs, ... }: {
    imports = [ self.nixosModules.meta ];   # żeby config.my.* działał
                                            # (zarejestrowane przez meta.nix przez flake.modules)

    time.timeZone = "Europe/Warsaw";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "pl2";

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # Cache dla Nixpkgs żeby nie rekompilować lokalnie
      trusted-users = [ "root" "@wheel" ];
      substituters = [
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    nixpkgs.config.allowUnfree = true;

    # OS version
    system.stateVersion = config.my.stateVersion;
  };
}

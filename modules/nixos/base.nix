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

    system.stateVersion = config.my.stateVersion;
  };
}

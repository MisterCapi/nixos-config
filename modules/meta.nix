# modules/meta.nix
{ ... }:
{
  flake.nixosModules.meta = { lib, ... }: {
    options.my = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "mrcapi";
      };
      stateVersion = lib.mkOption {
        type = lib.types.str;
        default = "26.05";
      };
    };
  };
}

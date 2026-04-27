{ ... }:
{
  flake.nixosModules.packages-common = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      nushell
      git
      wget
      curl
    ];
  };
}

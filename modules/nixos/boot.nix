{ ... }:
{
  flake.nixosModules.boot = { pkgs, ... }: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.preLVMCommands = "${pkgs.kbd}/bin/setleds +num";
  };
}

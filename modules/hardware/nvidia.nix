{ ... }:
{
  flake.nixosModules.nvidia = { config, pkgs, ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      nvidiaSettings = true;           # dostęp do nvidia-settings GUI
      powerManagement.enable = false;  # PC (desktop), nie potrzebujesz; true tylko dla laptopów z NVIDIĄ
    };
    hardware.graphics.enable = true;
  };
}

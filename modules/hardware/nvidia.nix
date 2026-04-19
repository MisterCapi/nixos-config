{ ... }:
{
  flake.nixosModules.nvidia = { config, ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    hardware.graphics.enable = true;
  };
}

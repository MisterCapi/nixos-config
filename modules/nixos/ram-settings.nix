{ ... }:
{
  flake.nixosModules.ram-settings = {
    zramSwap = {
      enable = true;
      memoryPercent = 50;
    };
  };
}

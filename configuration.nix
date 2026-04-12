{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "pl2";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
  };
  hardware.graphics.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb.layout = "pl";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  users.users.mrcapi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
  };

  environment.systemPackages = with pkgs; [
    ghostty
    neovim
    tmux
    git
    wget
    curl
    htop
    firefox
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 16384;
  }];

  services.openssh.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}

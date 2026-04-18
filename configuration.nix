{ config, lib, pkgs, ... }:

let
  username = "mrcapi";
  os_version = "26.05";
in
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
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb.layout = "pl";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
    initialPassword = "changeme";
  };

  users.users.root.initialPassword = "changeme";

  environment.systemPackages = with pkgs; [
    ghostty
    neovim
    tmux
    git
    wget
    curl
    htop
    firefox
    opencode
    telegram-desktop
    discord
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # swap: only zram (above), no swapfile needed on btrfs

  services.openssh.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = os_version;

  boot.initrd.preLVMCommands = "${pkgs.kbd}/bin/setleds +num";
}

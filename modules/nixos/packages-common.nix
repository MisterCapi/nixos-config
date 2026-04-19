{ ... }:
{
  flake.nixosModules.packages-common = { pkgs, ... }: {
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
  };
}

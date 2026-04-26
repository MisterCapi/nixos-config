{ ... }:
{
  flake.homeModules.tmux = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      extraConfig = ''
        set -g default-command "${pkgs.nushell}/bin/nu"
      '';
    };
  };
}

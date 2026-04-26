{ ... }:
{
  flake.homeModules.tmux = {
    programs.tmux = {
      enable = true;
      extraConfig = ''
        set -g default-command "${pkgs.nushell}/bin/nu"
      '';
    };
  };
}

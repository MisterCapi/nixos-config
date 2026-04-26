{ ... }: 
{
  flake.homeModules.nix-your-shell = { pkgs, ... }: {
    programs.nix-your-shell = {
      enable = true;
      package = pkgs.nix-your-shell;
      enableNushellIntegration = true;
    };
  };
}

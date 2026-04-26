{ ... }: 
{
  flake.homeModules.eza = {
    programs.eza = {
      enable = true;
      colors = "auto";
      enableNushellIntegration = true;
      extraOptions = [ "--group-directories-first" ];
      git = true;
      icons = "auto";
      # Colors are from terminal (Stylix should work, but in case it doesn't lookup themes)
      # theme = https://github.com/eza-community/eza-themes/blob/main/themes/rose-pine.yml
    };
  };
}

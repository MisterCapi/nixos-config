{ ... }: {
  flake.homeModules.ghostty = { ... }: {
    programs.ghostty = {
      enable = true;
      settings = {
        command = ''bash -lc "exec nu"'';
      };
    };
  };
}

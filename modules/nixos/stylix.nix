{ inputs, ... }: {
  flake.nixosModules.stylix = { pkgs, ... }: 
  let
    original = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/ly/wallhaven-lywpjl.jpg";
      hash = "sha256-EyGRsayeT1YDASaet4HYn/42ucAV+CaF21KMsIFPHNY=";
    };

    wallpaper = pkgs.runCommand "wallpaper-rose-pine.png" {
      buildInputs = [ pkgs.lutgen ];
    } ''
        lutgen apply --palette rose-pine ${original} -o $out
    '';
  in {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      image = wallpaper;
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
        sizes.terminal = 13;
      };

      autoEnable = true;
      targets.firefox.profileNames = [ "default" ];
    };
  };
}

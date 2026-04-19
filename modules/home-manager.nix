{ self, inputs, ... }:
{
  flake.nixosModules.home-manager = { config, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; }; # dodatkowe args dla home modules

      users.${config.my.username} = {
        imports = [
	  # === Dependencies (zewnętrzne flake'i dodające opcje do HM) ===
          inputs.plasma-manager.homeModules.plasma-manager

          # === Globalne moduły - aktywne na każdym hoście ===
          # np. self.homeModules.git, self.homeModules.neovim
          # host-specific rzeczy (plasma, hyprland) idą do hosts/<nazwa>/default.nix
	  self.homeModules.niri
        ];
        home.username = config.my.username;
        home.homeDirectory = "/home/${config.my.username}";
        home.stateVersion = config.my.stateVersion;
      };
    };
  };
}

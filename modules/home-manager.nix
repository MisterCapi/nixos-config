{ self, inputs, ... }:
{
  imports = [ inputs.home-manager.flakeModules.default ];

  flake.nixosModules.home-manager = { config, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; }; # dodatkowe args dla home modules

      users.${config.my.username} = {
        imports = [
          # === Globalne moduły - aktywne na każdym hoście ===
          # np. self.homeModules.git, self.homeModules.neovim
          # host-specific rzeczy idą do hosts/<nazwa>/default.nix
	  self.homeModules.niri
	  self.homeModules.eza
	  self.homeModules.bash 
	  # replace it later with better shell
        ];
        home.username = config.my.username;
        home.homeDirectory = "/home/${config.my.username}";
        home.stateVersion = config.my.stateVersion;
      };
    };
  };
}

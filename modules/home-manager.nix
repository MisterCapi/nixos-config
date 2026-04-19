{ inputs, ... }:
{
  flake.nixosModules.home-manager = { config, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; }; # Dodatkowe args dla home modules

      users.${config.my.username} = {
        imports = [
          inputs.plasma-manager.homeModules.plasma-manager
          # tu user dokłada rozszerzenia homa managera jak chce deklarować nowe home modules dla nich
        ];
        home.username = config.my.username;
        home.homeDirectory = "/home/${config.my.username}";
        home.stateVersion = config.my.stateVersion;
      };
    };
  };
}

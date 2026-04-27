{ self, inputs, lib, ... }:
{
  imports = [ inputs.home-manager.flakeModules.default ];

  flake.nixosModules.home-manager = { config, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; }; # dodatkowe args dla home modules
      backupFileExtension = "hm-bak";
      overwriteBackup = true;
      users.${config.my.username} = {
          # === Globalne moduły - aktywne na każdym hoście ===
          # np. self.homeModules.git, self.homeModules.neovim
          # host-specific rzeczy idą do hosts/<nazwa>/default.nix i powinny być nazywane z prefixem "_"
	  imports = builtins.attrValues (
            lib.filterAttrs (name: _: !lib.hasPrefix "_" name) self.homeModules
	  );

          # Globalne ustawienia stylix - applies to all hosts
          stylix.targets.firefox.profileNames = [ "default" ];
        home.username = config.my.username;
        home.homeDirectory = "/home/${config.my.username}";
        home.stateVersion = config.my.stateVersion;
      };
    };
  };
}

{ self, inputs, ... }:
let
  hostname = "laptop";
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };
    modules = [
      ./_hardware.nix
      ./_disko.nix
      inputs.disko.nixosModules.disko

      self.nixosModules.base
      self.nixosModules.boot
      self.nixosModules.networking
      self.nixosModules.users
      self.nixosModules.audio
      self.nixosModules.plasma
      self.nixosModules.performance
      self.nixosModules.packages-common
      # BEZ nvidia
      self.nixosModules.home-manager

      {
        networking.hostName = hostname;
        home-manager.users.mrcapi.imports = [
          self.homeModules.plasma
        ];
      }
    ];
  };
}

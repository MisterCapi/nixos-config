{ self, inputs, ... }:
let
  hostname = "pc";
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };
    modules = [
      # host-specific, explicit bo underscore
      ./_hardware.nix
      ./_disko.nix
      inputs.disko.nixosModules.disko

      # features z rejestru
      self.nixosModules.base
      self.nixosModules.boot
      self.nixosModules.networking
      self.nixosModules.users
      self.nixosModules.audio
      self.nixosModules.plasma
      self.nixosModules.ram-settings
      self.nixosModules.packages-common
      self.nixosModules.nvidia          # <-- tylko PC
      self.nixosModules.home-manager

      # nakładki tego hosta
      {
        networking.hostName = hostname;

        # dokładamy home modules dla tego hosta
        home-manager.users.mrcapi.imports = [
          self.homeModules.plasma
        ];
      }
    ];
  };
}

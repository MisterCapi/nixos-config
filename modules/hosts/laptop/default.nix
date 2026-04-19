{ self, inputs, ... }:
let
  hostname = "laptop";
  commonModules = import ../_common.nix { inherit self; };
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };
    modules = commonModules ++ [
      # === Hardware tego hosta (underscore = host-specific, nie w rejestrze) ===
      ./_hardware.nix
      ./_disko.nix
      inputs.disko.nixosModules.disko

      # === Moduły tylko dla tego hosta ===
      # dodawane jako self.nixosModules.<nazwa_modułu>

      # === Inline overrides host-level ===
      ({ config, ... }: {
        networking.hostName = hostname;

        # home modules aktywne tylko na tym hoście
        home-manager.users.${config.my.username}.imports = [
          # dodawane jako self.homeModules.<nazwa_modułu>
        ];
      })
    ];
  };
}

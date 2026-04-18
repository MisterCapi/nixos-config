{
  description = "My personal NixOS config";

  inputs = {
    # Channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake parts (allows to partition the flake into modules and import them here)
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Wrapper modules (idk what is does yet -> TODO: learn)
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; }
    (inputs.import-tree ./modules);
}

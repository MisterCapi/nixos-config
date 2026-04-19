{
  description = "My personal NixOS config";

  inputs = {
    # Channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake parts (allows to partition the flake into modules and import them here)
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

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

    # Wsparcie hardware dla laptopa
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; }
    (inputs.import-tree ./modules);
}

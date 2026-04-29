{
  description = "My personal NixOS config";

  inputs = {
    # =-=-=-= BASE =-=-=-=

    # Channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake parts (allows to partition the flake into modules and import them here)
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wsparcie hardware dla laptopa
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # =-=-=-= STYLING =-=-=-=

    # Stylix to make everything look RosePine
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rosepine-firefox = {
      url = "github:rose-pine/firefox";
      flake = false;
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; }
    (inputs.import-tree ./modules);
}

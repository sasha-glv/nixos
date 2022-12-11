{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    emacs.url = "github:nix-community/emacs-overlay";
    helix.url = "github:helix-editor/helix";
  };

  outputs = inputs @ { self, nixpkgs,  ... }:
    let
      inherit (nixpkgs) lib;
      inherit (builtins) listToAttrs map;
      system = "x86_64-linux";
      overlays = [ inputs.neovim-nightly.overlay inputs.emacs.overlay ];
      mylib = import ./lib { inherit lib;  };
    in {
      nixosConfigurations = listToAttrs                       # { thror = <system> }
        (map
          (host: {name = host.name; value = ( mylib.mkHost {inherit inputs overlays; host = host; system = system;});})                                                  # { name = "thror"; value = <system> }
          (import ./hosts));
    };
}

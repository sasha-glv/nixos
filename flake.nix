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

  outputs = inputs @ { self, nixpkgs, home-manager, neovim-nightly, helix,  ... }:
    let
      inherit (nixpkgs) lib;
      inherit (builtins) listToAttrs map;
      system = builtins.currentSystem;
      overlays = [ inputs.neovim-nightly.overlay inputs.emacs.overlay ];
      mylib = import ./lib { inherit lib home-manager nixpkgs overlays; };
    in {
      nixosConfigurations = listToAttrs                       # { thror = <system> }
        (map
          (n: {name = n; value = ( mylib.mkHost n system);})  # { name = "thror"; value = <system> }
          ((mylib.readHosts ./hosts)));                       # [ "thror" ]
    };
}

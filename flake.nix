{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      inherit (nixpkgs) lib;
      inherit (builtins) listToAttrs map;
      system = "x86_64-linux";
      mylib = import ./lib { lib = lib; home-manager = home-manager; };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [];
      };
    in {
      nixosConfigurations = listToAttrs                       # { thror = <system> }
        (map
          (n: {name = n; value = ( mylib.mkHost n system );}) # { name = "thror"; value = <system> }
          ((mylib.readHosts ./hosts)));                       # [ "thror" ]
    };
}

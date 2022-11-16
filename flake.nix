{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };
  outputs = inputs @ { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      inherit (builtins) listToAttrs map;
      system = "x86_64-linux";
      mylib = import ./lib { lib = lib; };
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

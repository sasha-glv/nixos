{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";  # for packages on the edge
  };
  outputs = inputs @ { self, nixpkgs, ... }:
  let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    mylib = import ./lib { lib = lib; };
    pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [];
    };
  in {
    nixosConfigurations = {
      # thror = lib.nixosSystem {
      #   inherit system;
      #   modules = import ./modules ++ [./hosts/thror];
      # };
      thror = mylib.mkHost "thror" system;
    };
  };
}

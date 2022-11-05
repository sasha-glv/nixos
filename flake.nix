{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";             # primary nixpkgs
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";  # for packages on the edge
  };
  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:
  let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [];
    };
  in {
    nixosConfigurations = {
      thror = lib.nixosSystem {
        system = system;
        modules = [
          ./modules/k8s_haproxy.nix
          ./hosts/thror
        ];
      };
    };
  };
}

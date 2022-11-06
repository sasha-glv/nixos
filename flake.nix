{
  description = "System config";

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";  # for packages on the edge
  };
  outputs = inputs @ { self, nixpkgs-unstable, ... }:
  let
    inherit (nixpkgs-unstable) lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [];
    };
  in {
    nixosConfigurations = {
      thror = lib.nixosSystem {
        system = system;
        pkgs = pkgs;
        modules = [
          ./modules/k8s_haproxy.nix
          ./hosts/thror
        ];
      };
    };
  };
}

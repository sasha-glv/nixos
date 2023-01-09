{lib, ... }:
rec {
  mkHost = {host, system, inputs, overlays, ...}:
    let
    in lib.nixosSystem {
      system = host.system;
      specialArgs = { host = host.name; inherit system inputs overlays; };
      modules = [
        ../hosts/${host.name}
        
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = overlays;
        }
        inputs.home-manager.nixosModules.home-manager
        {
          inherit (import ../users { inherit (inputs) nixpkgs;}) users;
          home-manager = {
            users.sashka = import ../users/sashka;
            extraSpecialArgs = {
              inherit (host) gui;
            };
            useGlobalPkgs = true;
          };
        }
      ] ++ (import ../modules) 
      ++ (if host.hardware != "" then [ inputs.nixos-hardware.nixosModules.${host.hardware} ] else []);
    };
}

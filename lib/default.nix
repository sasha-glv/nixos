{lib, ... }:
{
  mkHost = {host, system, inputs, overlays, ...}: lib.nixosSystem {
    system = if host == "dolguldur" then "aarch64-linux" else system;
    modules = [
      ../hosts/${host}
      { nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = overlays; }
      /* inputs.helix */
      inputs.home-manager.nixosModules.home-manager
      {
        inherit (import ../users { inherit (inputs) nixpkgs;}) users;
        home-manager = {
          users.sashka = import ../users/sashka;
          useGlobalPkgs = true;
        };
      }
    ] ++ (import ../modules);
  };

  readHosts = hostsPath: let
    inherit (lib) attrsets;
  in
    attrsets.mapAttrsToList (n: v: n)                                               # [ "thror" ]
      (attrsets.filterAttrs (n: v: v == "directory") (builtins.readDir hostsPath)); # { thror = "directory" }

}

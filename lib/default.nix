{home-manager, lib, ... }:
{
  mkHost = host: system: lib.nixosSystem {
    inherit system;
    modules = [
      ../hosts/${host}
      home-manager.nixosModules.home-manager
      {
        inherit (import ../users {}) users;
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

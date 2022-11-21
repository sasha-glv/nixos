{home-manager, lib, ... }:
{
  mkHost = host: system: lib.nixosSystem {
    inherit system;
    modules = [
      ../hosts/${host}
      home-manager.nixosModules.home-manager
      {
        users.users = {
          inherit (import ../users/sashka {}) sashka;
          inherit (import ../users/root {}) root;
        };
        home-manager = {
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

{lib, ... }:
{
  mkHost = host: system: lib.nixosSystem {
    inherit system;
    modules = (import ../modules) ++ [../hosts/${host}];
  };

  readHosts = hostsPath: let
    inherit (lib) attrsets;
  in
    attrsets.mapAttrsToList (n: v: n)                                               # [ "thror" ]
      (attrsets.filterAttrs (n: v: v == "directory") (builtins.readDir hostsPath)); # { thror = "directory" }
}

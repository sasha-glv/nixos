{lib, ... }:
{
  mkHost = host: system: lib.nixosSystem {
    inherit system;
    modules = (import ../modules) ++ [../hosts/${host}];
  };
}

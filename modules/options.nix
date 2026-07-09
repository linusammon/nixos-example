{ lib, ... }:
{
  options =
    let
      inherit (lib) mkOption types;
    in
    with types;
    {
      modules = mkOption { type = lazyAttrsOf (lazyAttrsOf deferredModule); };
      nixosConfigurations = mkOption { type = lazyAttrsOf raw; };
      devShells = mkOption { type = lazyAttrsOf (functionTo anything); };
      packages = mkOption { type = lazyAttrsOf (functionTo package); };
      formatter = mkOption { type = functionTo package; };
    };
}

{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
  inherit (types)
    attrsOf
    functionTo
    unspecified
    package
    ;
in
{
  options = {
    modules = mkOption {
      type = attrsOf unspecified;
      default = { };
    };
    nixosConfigurations = mkOption {
      type = attrsOf unspecified;
      default = { };
    };
    devShells = mkOption {
      type = attrsOf (functionTo unspecified);
      default = { };
    };
    packages = mkOption {
      type = attrsOf (functionTo package);
      default = { };
    };
    formatter = mkOption {
      type = functionTo package;
    };
  };
}

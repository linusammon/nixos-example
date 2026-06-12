{ lib, ... }: {
  options = {
    modules = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };
    nixosConfigurations = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };
    devShells = lib.mkOption {
      type = lib.types.attrsOf (lib.types.functionTo lib.types.unspecified);
      default = { };
    };
    packages = lib.mkOption {
      type = lib.types.attrsOf (lib.types.functionTo lib.types.unspecified);
      default = { };
    };
    formatter = lib.mkOption {
      type = lib.types.functionTo lib.types.package;
    };
  };
}

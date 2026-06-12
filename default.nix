{
  tackOverrides ? { },
}:
let
  inputs = import ./.tack { overrides = tackOverrides; };

  lib = inputs.nixpkgs.lib;
  inherit (lib) evalModules hasPrefix mapAttrs;
  inherit (lib.fileset) fileFilter toList;

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem =
    f:
    builtins.listToAttrs (
      map (system: {
        name = system;
        value = f inputs.nixpkgs.legacyPackages.${system};
      }) systems
    );

  importTree = path: toList (fileFilter (file: file.hasExt "nix" && !(hasPrefix "_" file.name)) path);

  config =
    (evalModules {
      modules = importTree ./modules;
      specialArgs = { inherit inputs lib; };
    }).config;
in
config
// {
  devShells = perSystem (pkgs: mapAttrs (_: f: f pkgs) config.devShells);
  packages = perSystem (pkgs: mapAttrs (_: f: f pkgs) config.packages);
  formatter = perSystem (pkgs: config.formatter pkgs);
}

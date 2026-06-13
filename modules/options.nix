{ lib, ... }:
let
  inherit (lib)
    mkOptionType
    mkOption
    types
    mergeDefinitions
    ;
  inherit (types)
    lazyAttrsOf
    deferredModule
    functionTo
    unspecified
    package
    ;
  inherit (builtins)
    isFunction
    isAttrs
    partition
    concatStringsSep
    foldl'
    attrNames
    listToAttrs
    ;

  recursive = mkOptionType {
    name = "recursive";
    check = v: isFunction v || isAttrs v;
    merge =
      loc: defs:
      let
        inherit (partition (d: isFunction d.value) defs) right wrong;
      in
      if right != [ ] && wrong != [ ] then
        throw "recursive: cannot mix leaves and branches at ${concatStringsSep "." loc}"
      else if wrong == [ ] then
        deferredModule.merge loc defs
      else
        let
          defsByKey = foldl' (
            acc: d:
            foldl' (
              acc': key:
              acc'
              // {
                ${key} = (acc'.${key} or [ ]) ++ [
                  {
                    inherit (d) file;
                    value = d.value.${key};
                  }
                ];
              }
            ) acc (attrNames d.value)
          ) { } wrong;
        in
        listToAttrs (
          map (key: {
            name = key;
            value = (mergeDefinitions (loc ++ [ key ]) recursive defsByKey.${key}).mergedValue;
          }) (attrNames defsByKey)
        );
  };
in
{
  options = {
    modules = mkOption { type = recursive; };
    nixosConfigurations = mkOption { type = lazyAttrsOf unspecified; };
    devShells = mkOption { type = lazyAttrsOf (functionTo unspecified); };
    packages = mkOption { type = lazyAttrsOf (functionTo package); };
    formatter = mkOption { type = functionTo package; };
  };
}

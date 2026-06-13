{
  modules.nixos.programs.gimp = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.zed-editor ];
  };
}

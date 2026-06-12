{ config, lib, ... }:
{
  modules.nixos.common = {
    system.stateVersion = "26.05";
  };

  modules.nixos.programs.firefox = {
    programs.firefox.enable = true;
  };

  modules.nixos.programs.gimp = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gimp ];
  };

  modules.nixos.my-laptop = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    fileSystems."/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };

    boot.loader.grub.devices = [ "/dev/sda" ];

    imports = with config.modules.nixos; [
      programs.firefox
      programs.gimp
    ];
  };

  nixosConfigurations.my-laptop = lib.nixosSystem {
    modules = with config.modules.nixos; [
      common
      my-laptop
    ];
  };

  devShells.default =
    pkgs:
    pkgs.mkShell {
      packages = [ pkgs.tack ];
    };

  packages.default = pkgs: pkgs.hello;

  formatter = pkgs: pkgs.nixfmt-tree;
}

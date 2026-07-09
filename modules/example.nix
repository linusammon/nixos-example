{ config, lib, ... }:
{
  modules.nixos.common = _: {
    system.stateVersion = "26.05";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };

  modules.nixos.firefox = {
    programs.firefox.enable = true;
  };

  modules.nixos.gimp = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gimp ];
  };

  modules.nixos.my-laptop = {
    fileSystems."/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };

    boot.loader.grub.devices = [ "/dev/sda" ];

    imports = with config.modules.nixos; [
      common
      firefox
      gimp
    ];
  };

  nixosConfigurations.my-laptop = lib.nixosSystem {
    modules = with config.modules.nixos; [
      my-laptop
    ];
  };

  devShells.default =
    pkgs:
    pkgs.mkShell {
      packages = [ pkgs.hello ];
    };

  packages.default = pkgs: pkgs.hello;

  formatter = pkgs: pkgs.nixfmt-tree;
}

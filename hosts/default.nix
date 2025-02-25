{
  inputs,
  lib,
  ...
}: let
  inherit (lib) nixosSystem;
in {
  padock = nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
      ./padock
    ];
  };
}

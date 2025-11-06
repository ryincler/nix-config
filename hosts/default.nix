{
  inputs,
  lib,
  ...
}: let
  inherit (lib) nixosSystem;
in {
  plaptop = nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
      ./plaptop
      ../modules
    ];
  };

  terra = nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      ./terra
      ../modules
    ];
  };

  ryou = nixosSystem {
    system = "aarch64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      ./ryou
      ../modules
    ];
  };
  yamada = nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      ./yamada
      ../modules
    ];
  };
}

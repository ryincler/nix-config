{
  description = "New flake for my system configuration";
  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
  in {
    nixosConfigurations = import ./hosts {inherit inputs lib;};
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    hyprland = {
      url = "github:hyprwm/hyprland";
    };

    swww.url = "github:lgfae/swww";

    nvf = {
      url = "github:notashelf/nvf/v0.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl.url = "github:ezkea/aagl-gtk-on-nix";

    niri-flake.url = "github:sodiboo/niri-flake";
  };
}

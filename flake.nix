{
  description = "New flake for my system configuration";
  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
  in {
    nixosConfigurations = import ./hosts {inherit inputs lib;};
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl.url = "github:ezkea/aagl-gtk-on-nix";
  };
}

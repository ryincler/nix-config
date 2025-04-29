{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf mkMerge;
  cfg = config.modules.programs.gaming.aagl;
in {
  imports = [
    inputs.aagl.nixosModules.default
  ];
  options = {
    modules.programs.gaming.aagl.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables AAGL launchers.";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      anime-game-launcher.enable = true;
      honkers-railway-launcher.enable = true;
    };

    nix.settings = {
      substituters = mkMerge [["https://ezkea.cachix.org"]];
      trusted-public-keys = mkMerge [["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="]];
    };
  };
}

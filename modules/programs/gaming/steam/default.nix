{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption;
  cfg = config.modules.programs.gaming.steam;
in {
  options = {
    modules.programs.gaming.steam.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables steam.";
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin.steamcompattool
      ];
    };

    environment.systemPackages = [pkgs.mangohud];
  };
}

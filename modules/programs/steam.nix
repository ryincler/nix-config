{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

in {
  options = {
    steam.enable = mkEnableOption "steam";
  };

  config = mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin.steamcompattool
      ];
    };
  };
}

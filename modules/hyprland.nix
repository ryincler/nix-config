{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkForce mkDefault mkIf;
  hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
in {
  options = {
    hyprland.enable = mkEnableOption "Hyprland compositor";
  };

  config = mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = mkForce true;
      xwayland.enable = mkDefault true;
      package = mkDefault hyprlandPackage;
    };
  };
}

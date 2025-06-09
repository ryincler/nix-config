{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.display.wm.wayland.niri;
  niriPkg = pkgs.niri-unstable;
in {
  imports = [inputs.niri-flake.nixosModules.niri];
  options.modules.display.wm.wayland.niri = {
      enable = mkEnableOption "niri";
      xwayland.enable = mkEnableOption "XWayland in Niri.";
  };
  config = mkIf cfg.enable {
    nixpkgs.overlays = [inputs.niri-flake.overlays.niri];
    programs.niri = {
      enable = true;
      package = niriPkg;
    };

    niri-flake.cache.enable = true;

    environment = mkIf cfg.xwayland.enable {
      systemPackages = with pkgs; [
        xwayland-satellite
      ];
      sessionVariables = {
        DISPLAY = ":0";
      };
    };
  };
}

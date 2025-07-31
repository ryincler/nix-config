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

    environment = {
      systemPackages = with pkgs; [
        wl-clipboard
        fuzzel
        xdg-utils
        brightnessctl
        inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww
      ] ++ lib.optionals cfg.xwayland.enable [xwayland-satellite];

      sessionVariables.NIXOS_OZONE_WL = "1";
    };
    services.displayManager.sessionPackages = [niriPkg];
  };
}

{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkDefault mkIf;
  hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  swwwPackage = inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww;
  cfg = config.modules.display.wm.wayland.hyprland;
in {
  options = {
    modules.display.wm.wayland.hyprland.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the Hyprland compositor";
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = mkDefault true;
      package = mkDefault hyprlandPackage;
    };

    environment = {
      systemPackages = with pkgs;
        [
          wl-clipboard # maybe some of these packages can be moved for a more general config
          xdg-utils
          grim
          slurp
          brightnessctl
          bibata-cursors
          fuzzel
          swwwPackage
        ];

      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    services.displayManager.sessionPackages = [hyprlandPackage];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    nix.settings = {
      # Cachix for Hyprland setup
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}

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
  hyprlandNixpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
      xwayland.enable = true;
      package = hyprlandPackage;
    };

    hardware.graphics = {
      package = lib.mkOverride 1200 hyprlandNixpkgs.mesa;
      package32 = lib.mkOverride 1200 hyprlandNixpkgs.pkgsi686Linux.mesa;
    };

    environment = {
      systemPackages = with pkgs;
        [
          hyprpolkitagent
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

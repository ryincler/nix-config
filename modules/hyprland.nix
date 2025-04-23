{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault mkIf;
  hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
in {
  options = {
    hyprland.enable = mkEnableOption "Hyprland compositor";
  };

  config = mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = mkDefault true;
      package = mkDefault hyprlandPackage;
    };

    environment = {
      systemPackages = with pkgs; [
        wl-clipboard # maybe some of these packages can be moved for a more general config
        xdg-utils
        grim
        slurp
        catppuccin-cursors.mochaSky
        brightnessctl
        fuzzel
      ] ++ [inputs.swww.packages.${pkgs.system}.swww]; # TODO: this is ugly 

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
  };
}

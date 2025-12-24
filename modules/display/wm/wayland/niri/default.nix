{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.display.wm.wayland.niri;
  niriPkg = pkgs.niri;
in {
  options.modules.display.wm.wayland.niri = {
      enable = mkEnableOption "niri";
      xwayland.enable = mkEnableOption "XWayland in Niri.";
  };
  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = niriPkg;
    };

    environment = {
      systemPackages = with pkgs; [
        bibata-cursors
        wl-clipboard
        fuzzel
        xdg-utils
        brightnessctl
        inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww
      ] ++ lib.optionals cfg.xwayland.enable [xwayland-satellite];

      sessionVariables.NIXOS_OZONE_WL = "1";
    };
    services.displayManager.sessionPackages = [niriPkg];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    security.polkit.enable = true;
    systemd.user.services.niri-polkit = {
      description = "PolicyKit Authentication Agent";
      wantedBy = [ "niri.service" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption concatStringsSep getExe;

  cfg = config.modules.services.login.greetd;

  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPaths = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];

  defaultSession = {
    user = "greeter";
    command = concatStringsSep " " [
      (getExe pkgs.tuigreet)
      "--time"
      "--remember"
      "--remember-user-session"
      "--asterisks"
      "--sessions '${sessionPaths}'"
    ];
  };

in {
  options = {
    modules.services.login.greetd = {
      enable = mkEnableOption "Greetd with tuigreet";
    };
  };
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = defaultSession;
      };
    };
  };
}


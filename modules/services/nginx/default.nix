{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.modules.services.nginx;
in {
  options = {
    modules.services.nginx = {
      enable = mkEnableOption "Nginx";
    };
  };
  config = mkIf cfg.enable {
    # By default, assume we're going to use https
    modules.security.acme.enable = mkDefault true;

    services.nginx.enable = true;
    networking.firewall.allowedTCPPorts = [443];
  };
}

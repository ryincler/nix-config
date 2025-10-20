{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.services.nginx;
in {
  options = {
    modules.services.nginx = {
      enable = mkEnableOption "Nginx";
    };
  };
  config = mkIf cfg.enable {
    services.nginx.enable = true;
  };
}

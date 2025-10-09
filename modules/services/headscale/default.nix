{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.services.headscale;
in {
  options = {
    modules.services.headscale.enable = mkEnableOption "Headscale hosting";
  };

  config = mkIf cfg.enable {
    services = {
      headscale = {
        enable = true;
        address = "127.0.0.1";
        port = 8080;
      };
    };
  };

}


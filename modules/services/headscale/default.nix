{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.services.headscale;
in {
  imports = [
    ./dns.nix
  ];
  options = {
    modules.services.headscale.enable = mkEnableOption "Headscale hosting";
  };

  config = mkIf cfg.enable {
    services = {
      headscale = {
        enable = true;
        address = "0.0.0.0";
        port = 8080;

        settings = {
          server_url = "http://140.238.143.51:8080";
          metrics_listen_addr = "127.0.0.1:9090";
        };
      };
    };
  };

}


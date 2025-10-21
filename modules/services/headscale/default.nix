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
        address = "127.0.0.1";
        port = 8080;

        settings = {
          server_url = "https://hs.ryincler.dev";
          metrics_listen_addr = "127.0.0.1:9090";
        };
      };
      nginx.virtualHosts."hs.ryincler.dev" = {
        forceSSL = true;
        enableACME = true;
        http3 = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString config.services.headscale.port}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

}


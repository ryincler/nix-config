{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.security.acme;
in {
  options.modules.security.acme = {
    enable = mkEnableOption "ACME to get TLS certs from letsencrypt";
  };

  config = mkIf cfg.enable {
    # Accept letsencrypt TOS 
    security.acme = {
      acceptTerms = true;
      defaults.email = "ryincler@proton.me";
      certs."ryincler.dev" = {
        dnsProvider = "spaceship";
      };
    };

  };

}

{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.networking.firewall;
in {
  options = {
    modules.networking.firewall = {
      enable = mkEnableOption "firewall config";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        enable = true;
        # Personal tailscale network, should be safe
        trustedInterfaces = [ "tailscale0" ];
      };

      nftables = {
        enable = true;
        # flush rules to force declaring in config
        flushRuleset = true;
      };
    };
  };
}


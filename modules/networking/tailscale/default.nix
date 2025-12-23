{
  config,
  lib,
  ...
}: let
  cfg = config.modules.networking.tailscale;
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  options = {
    modules.networking.tailscale = {
      enable = mkEnableOption "Tailscale configuration";
    };
  };
  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      useRoutingFeatures = mkDefault "both";
      openFirewall = true;
    };
  };
}

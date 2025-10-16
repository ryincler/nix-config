{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.networking.networkmanager;
in {
  options = {
    modules.networking.networkmanager = {
      enable = mkEnableOption "NetworkManager config";
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };
  };
}

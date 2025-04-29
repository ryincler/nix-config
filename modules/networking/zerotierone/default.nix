{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkIf;
  cfg = config.modules.networking.zerotierone;
in {
  options = {
    modules.networking.zerotierone.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables conection to a private ZeroTierOne network.";
    };
  };

  config = mkIf cfg.enable {
    services.zerotierone = {
      enable = true;
      joinNetworks = ["3efa5cb78a7cc679"];
    };
  };
}

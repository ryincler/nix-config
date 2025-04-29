{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf;
  cfg = config.modules.networking.sunshine;
in {
  options = {
    modules.networking.sunshine.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables desktop stream hosting using Sunshine.";
    };
  };

  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
    };
  };
}

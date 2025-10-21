{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf;
  cfg = config.modules.services.sunshine;
  
  sunshinePkg = pkgs.sunshine;

in {
  options = {
    modules.services.sunshine.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables desktop stream hosting using Sunshine.";
    };
  };

  config = mkIf cfg.enable {
    services.sunshine = {
      package = sunshinePkg;
      enable = true;
      autoStart = true;
      capSysAdmin = true;
    };
  };
}

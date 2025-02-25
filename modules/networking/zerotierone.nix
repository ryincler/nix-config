{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

in {
  options = {
    zerotierone.enable = mkEnableOption "connection to my zerotierone network";
  };

  config = mkIf config.zerotierone.enable {
    services.zerotierone = {
      enable = true;
      joinNetworks = [ "3efa5cb78a7cc679" ];
    };
  };
}

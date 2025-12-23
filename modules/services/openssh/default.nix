{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.services.openssh;
in {
  options = {
    modules.services.openssh = {
      enable = mkEnableOption "SSH configuration";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      ports = [30];
      settings = {
        PermitRootLogin = "no";
        ChallengeResponseAuthentication = "no";
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        UsePAM = false;
      };
    };
  };
}

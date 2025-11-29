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

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf;
  cfg = config.modules.networking.sunshine;

  sunshinePkg = pkgs.sunshine.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "LizardByte";
      repo = "Sunshine";
      rev = "0a942437e29d8c7938d8f07d2319e634fb295b9b";
      hash = "sha256-ae0Q0tVkxp+iPWjZL3vCsBjhLEC+oRBVV1CAomFcJtM=";
      fetchSubmodules = true;
    };
  };
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
      package = sunshinePkg;
      enable = true;
      autoStart = true;
      capSysAdmin = true;
    };
  };
}

{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkIf;
  cfg = config.modules.programs.terminal.foot;
in {
  options = {
    modules.programs.terminal.foot.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Foot as a terminal";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      foot
    ];
  };
}

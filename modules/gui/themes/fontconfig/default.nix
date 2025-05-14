{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.gui.themes.fontconfig;
in {
  options.modules.gui.themes.fontconfig = {
    enable = mkEnableOption "fonts";
    useMonoEverywhere = mkEnableOption "use mono fonts everywhere";
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;

      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [
            (
              if cfg.useMonoEverywhere
              then "Noto Sans Mono"
              else "Noto Serif"
            )
          ];
          sansSerif = [
            (
              if cfg.useMonoEverywhere
              then "Noto Sans Mono"
              else "Noto Sans"
            )
          ];
          monospace = [
            "Noto Sans Mono"
            "Symbols Nerd Font Mono"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };

      
      packages = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        nerd-fonts.symbols-only
        noto-fonts-cjk-sans # for Chinese, Japanese, and Korean
      ];
    };
  };
}

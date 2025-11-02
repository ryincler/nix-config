{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.gui.themes.fontconfig;
  monoFont = "Iosevka Fixed";
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
              then monoFont
              else "Noto Serif"
            )
          ];
          sansSerif = [
            (
              if cfg.useMonoEverywhere
              then monoFont
              else "Noto Sans"
            )
          ];
          monospace = [
            monoFont
            "Symbols Nerd Font Mono"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };

      packages = with pkgs; [
        (pkgs.callPackage ./iosevka-fixed.nix {})
        noto-fonts
        noto-fonts-color-emoji
        nerd-fonts.symbols-only
        noto-fonts-cjk-sans # for Chinese, Japanese, and Korean
      ];
    };
  };
}

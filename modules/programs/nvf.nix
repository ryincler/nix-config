{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
in {
  imports = [
    inputs.nvf.nixosModules.default
  ];
  options = {
    nvf.enable = mkEnableOption "Nvim config using nvf";
  };

  config = mkIf config.nvf.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
        lsp.enable = true;
        syntaxHighlighting = true;

        options = {
          expandtab = true;
          tabstop = 2;
          softtabstop = 2;
          shiftwidth = 2;
          backup = false;
          writebackup = true;
          swapfile = true;
        };

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          markdown.enable = true;
          bash.enable = true;
          java.enable = true;
          ts = {
            enable = true;
            format.enable = true;
          };
          nix = {
            enable = true;
          };
        };
      };
    };
  };
}

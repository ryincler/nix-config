{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf;
  cfg = config.modules.programs.editors.neovim;
in {
  imports = [
    inputs.nvf.nixosModules.default
  ];
  options = {
    modules.programs.editors.neovim.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables neovim with nvf config.";
    };
  };

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
        autopairs.nvim-autopairs.enable = true;
        autocomplete.nvim-cmp.enable = true;
        snippets.luasnip.enable = true;
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
          ts.enable = true;
          nix.enable = true;
          csharp.enable = true;
        };
      };
    };
  };
}

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
    environment.sessionVariables = {
      "EDITOR" = "nvim";
    };
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
            transparent = true;
          };

          diagnostics = {
            enable = true;
            config = {
              virtual_lines = true;
            };
          };
          git.enable = true;
          statusline.lualine.enable = true;
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
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;
            clang.enable = true;
            markdown.enable = true;
            bash.enable = true;
            java.enable = true;
            ts.enable = true;
            nix.enable = true;
          };
        };
      };
    };
  };
}

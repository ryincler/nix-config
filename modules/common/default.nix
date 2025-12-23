{lib, ...}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./nix.nix
  ];

  # Don't include nano as default, use vim instead
  programs.nano.enable = mkDefault false;
  programs.vim.enable = mkDefault true;
}


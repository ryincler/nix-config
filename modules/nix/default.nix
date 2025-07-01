{pkgs, ...}: {
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = ["flakes" "nix-command"];
      auto-optimise-store = true;
    };
  };
}

{pkgs, ...}: {
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = ["flakes" "nix-command" "repl-flake"];
      auto-optimise-store = true;
    };
  };
}

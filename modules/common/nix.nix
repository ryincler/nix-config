{pkgs, ...}: {
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = ["flakes" "nix-command"];
      auto-optimise-store = true;

      # All substituters should be added here, instead of other modules
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://ezkea.cachix.org"
      ];

      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      ];
    };
  };
}


{pkgs, ...}: {
  # See: https://lix.systems/blog/2025-06-27-lix-critical-bug/
  nixpkgs.overlays = [
    (final: prev: {
      lixPackageSets = prev.lixPackageSets.extend (final': prev': {
        lix_2_93 = prev'.lix_2_93.overrideScope (new: old: {
          lix = old.lix.overrideAttrs (new': old': {
            patches = (old'.patches or []) ++ [
              (final.fetchpatch2 {
                url = "https://gerrit.lix.systems/changes/lix~3510/revisions/7/patch?download";
                hash = "sha256-IStS350nq8JqhJNnltvbLZdyREV2Rrf4M5OvXtDhfuk=";
                decode = "base64 -d";
              })
            ];
          });
        });
      });
    })
  ];
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = ["flakes" "nix-command"];
      auto-optimise-store = true;
    };
  };
}

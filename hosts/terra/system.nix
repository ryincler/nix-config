{
  system.stateVersion = "25.11";

  networking.hostName = "terra";

  nixpkgs.hostPlatform = {
    #gcc.arch = "znver4";
    #gcc.tune = "znver4";
    system = "x86_64-linux";
  };

  nix.settings.system-features = [
    "nixos-test"
    "benchmark"
    "big-parallel"
    "kvm"
    "gccarch-znver4"
  ];
}

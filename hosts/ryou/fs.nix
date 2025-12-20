{
  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/srv".options = ["compress=zstd"];
    "/srv/storage".options = ["compress=zstd"];
  };
}

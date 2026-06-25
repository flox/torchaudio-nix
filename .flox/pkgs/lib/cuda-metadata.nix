# CUDA version metadata: version tag → overlay package set name and minimum driver version.
# Used by mkPyTorch.nix to select the correct CUDA toolkit overlay.
#
# Note: nixpkgs pins are NOT stored here — they vary per (pytorchVersion, pythonVersion)
# and are managed in pytorch-metadata.nix instead.
{
  "12_8" = {
    overlay = "cudaPackages_12_8";
    minDriver = "550";
  };
  "12_9" = {
    overlay = "cudaPackages_12_9";
    minDriver = "560";
  };
  "13_0" = {
    overlay = "cudaPackages_13";
    minDriver = "580";
  };
  "13_1" = {
    overlay = "cudaPackages_13_1";
    minDriver = "590";
  };
}

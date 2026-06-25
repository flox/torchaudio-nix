# TorchAudio metadata: (taVersion, pythonVersion) → build configuration.
# Keyed by "majorMinor-pythonMinor" (e.g., "2.10-313").
#
# Each entry provides everything needed to instantiate nixpkgs and build
# torchaudio for that combination. The generator script reads these entries
# to produce all valid (SM, ISA, CUDA) wrapper files.
#
# Note: upstream pytorch/audio has not released a 2.12.x as of 2026-06-23.
# Latest is 2.11.0 (published 2026-03-23). When upstream ships 2.12.x, add
# a "2.12-313" entry here and to TA_COMBOS in the generator scripts.
#
# Hashes prefetched 2026-06-23 via nix-prefetch-git --fetch-submodules.
{
  # ── TorchAudio 2.10.x (↔ PyTorch 2.10.x) ────────────────────────────
  "2.10-313" = {
    taVersion = "2.10.0";
    ptVersion = "2.10.0";
    nixpkgsPin = "0182a361324364ae3f436a63005877674cf45efb";
    pythonAttr = "python3Packages";
    sourceOverride = {
      version = "2.10.0";
      owner = "pytorch";
      repo  = "audio";
      rev   = "v2.10.0";
      hash  = "sha256-b1sjHVFXdNFDbdtXWSM2KisSRE/8IbzJI4rvzYQ4UMg=";
    };
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    # Per-CUDA-version nixpkgs pin overrides (reuse pytorch-nix 2.10's pins)
    cudaPinOverrides = {
      "13_0" = "6a030d535719c5190187c4cec156f335e95e3211";
      "13_1" = "2017d6d515f8a7b289fe06d3a880a7ec588c3900";
    };
    cpuPin = "6a030d535719c5190187c4cec156f335e95e3211";
  };

  # ── TorchAudio 2.11.x (↔ PyTorch 2.11.x) ────────────────────────────
  "2.11-313" = {
    taVersion = "2.11.0";
    ptVersion = "2.11.0";
    nixpkgsPin = "0182a361324364ae3f436a63005877674cf45efb";
    pythonAttr = "python3Packages";
    sourceOverride = {
      version = "2.11.0";
      owner = "pytorch";
      repo  = "audio";
      rev   = "v2.11.0";
      hash  = "sha256-TncROn9wfn5HOaIvupS2/KD9JCgwfHyfnbZRc+SiqJ0=";
    };
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    cudaPinOverrides = {
      "13_0" = "6a030d535719c5190187c4cec156f335e95e3211";
      "13_1" = "2017d6d515f8a7b289fe06d3a880a7ec588c3900";
    };
    cpuPin = "6a030d535719c5190187c4cec156f335e95e3211";
  };
}

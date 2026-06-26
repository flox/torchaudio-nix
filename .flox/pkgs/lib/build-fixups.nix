# build-fixups.nix — version-specific build workarounds for torchaudio.
#
# Returns an attrset with extra overlays, config, cmake flags, and shell
# snippets that must be applied for certain (taVersion, cudaVersion)
# combinations.
#
# Smaller than pytorch-nix's: torchaudio doesn't need the CCCL shim or the
# magma clockrate patch — those are torch's concerns. The torchaudio
# upstream nixpkgs derivation already carries the right system-library
# wiring (ffmpeg / sox / soundfile); we only override `src`, `version`,
# and substitute `torch` with the matching pytorch-nix build.
#
# Arguments:
#   taConfig:      Entry from torchaudio-metadata.nix
#   cudaVersion:   CUDA version string (e.g., "13_0") or null for CPU/MPS
#   torchOverride: A derivation to substitute for torch (the matching
#                  pytorch-nix variant).

{ taConfig, cudaVersion, torchOverride }:

let
  sourceOverride = taConfig.sourceOverride or null;
  hasSourceOverride = sourceOverride != null;

  isCuda13 = cudaVersion != null && builtins.match "13_.*" cudaVersion != null;

in {
  # ── Extra nixpkgs config ─────────────────────────────────────────────
  extraConfig =
    if hasSourceOverride && isCuda13
    then { allowBroken = true; }
    else {};

  # ── Extra overlays ──────────────────────────────────────────────────
  # Substitute the matching pytorch-nix torch build into the python
  # package set, and override torchaudio's src/version to the upstream
  # tag specified by sourceOverride.
  extraOverlays =
    if hasSourceOverride then [
      (final: prev: {
        ${taConfig.pythonAttr} = prev.${taConfig.pythonAttr}.override {
          overrides = pfinal: pprev: {
            torch = torchOverride;
            torchaudio = pprev.torchaudio.overrideAttrs (oldAttrs: rec {
              version = sourceOverride.version;
              src = prev.fetchFromGitHub {
                inherit (sourceOverride) owner repo rev hash;
                fetchSubmodules = true;
              };
              patches = [];
              # Soften strict `--replace-fail` (and legacy `--replace`) to
              # `--replace-warn` so upstream pattern changes don't fail the
              # build.
              postPatch = builtins.replaceStrings
                [ "--replace-fail " "--replace " ]
                [ "--replace-warn "  "--replace-warn " ]
                (oldAttrs.postPatch or "");
            });
          };
        };
      })
    ] else if torchOverride != null then [
      (final: prev: {
        ${taConfig.pythonAttr} = prev.${taConfig.pythonAttr}.override {
          overrides = pfinal: pprev: { torch = torchOverride; };
        };
      })
    ] else [];

  # ── Extra cmake flags ───────────────────────────────────────────────
  extraCmakeFlags =
    if hasSourceOverride then [
      "-DTORCH_BUILD_VERSION=${sourceOverride.version}"
    ] else [];

  # ── Extra preConfigure shell ────────────────────────────────────────
  extraPreConfigure =
    (if hasSourceOverride then ''
      export BUILD_VERSION=${sourceOverride.version}
      echo "${sourceOverride.version}" > version.txt
    '' else "")
    +
    # Bypass torch.utils.cpp_extension._check_cuda_version's strict
    # gcc-vs-CUDA-max check. nixpkgs ships gcc 14.3.0; CUDA 12.9's nominal
    # max is gcc 13.x, but it works correctly with gcc 14 in practice
    # (pytorch itself builds clean on the same toolchain). Inject a
    # sitecustomize.py via PYTHONPATH that monkey-patches the check to a
    # no-op before torchaudio's setup.py imports torch.
    ''
      mkdir -p $TMPDIR/torch-monkey
      cat > $TMPDIR/torch-monkey/sitecustomize.py << 'EOF'
import warnings
try:
    import torch.utils.cpp_extension as _ce
    _ce._check_cuda_version = lambda *a, **k: None
except Exception as e:
    warnings.warn(f"torch monkey-patch (skip _check_cuda_version) failed: {e}")
EOF
      export PYTHONPATH="$TMPDIR/torch-monkey:''${PYTHONPATH:-}"
    '';

  # ── Whether to clear patches ────────────────────────────────────────
  clearPatches = hasSourceOverride;
}

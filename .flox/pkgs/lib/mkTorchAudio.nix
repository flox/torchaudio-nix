# Parametric TorchAudio builder
# Creates optimized torchaudio variants for CUDA, CPU-only, and Darwin MPS
# backends. Each variant depends on a matching pytorch-nix torch build to
# preserve ABI compatibility.
#
# Arguments:
#   taVersion:       "2.10" | "2.11"
#   pythonVersion:   "313"
#   backend:         "cuda" | "cpu" | "mps"
#   sm:              SM architecture number (e.g., "90") — required for CUDA
#   isa:             CPU ISA key from cpu-isa.nix (e.g., "avx2", "armv9")
#                    — required for CUDA and CPU backends
#   cudaVersion:     "12_8" | "12_9" | "13_0" | "13_1" — required for CUDA
#   pytorchNixRoot:  Path to sibling pytorch-nix repo (default ../../../../pytorch-nix)

{ taVersion, pythonVersion, backend, sm ? null, isa ? null, cudaVersion ? null
, pytorchNixRoot ? ../../../../pytorch-nix }:

let
  # ── Lookup tables ─────────────────────────────────────────────────────
  cpuISAs   = import ./cpu-isa.nix;
  gpuMeta   = import ./gpu-metadata.nix;
  cudaMeta  = import ./cuda-metadata.nix;
  taMetas   = import ./torchaudio-metadata.nix;

  # ── Resolve configuration ────────────────────────────────────────────
  metaKey   = "${taVersion}-${pythonVersion}";
  taConfig  = taMetas.${metaKey};

  # ── Backend flags ────────────────────────────────────────────────────
  isCuda = backend == "cuda";
  isCpu  = backend == "cpu";
  isMps  = backend == "mps";

  # ── ISA configuration ───────────────────────────────────────────────
  isaConfig = if isa != null then cpuISAs.${isa} else null;
  platform  =
    if isMps then "aarch64-darwin"
    else isaConfig.platform;

  # ── CUDA-specific lookups ───────────────────────────────────────────
  smMeta   = if isCuda then gpuMeta.${sm}          else null;
  cudaInfo = if isCuda then cudaMeta.${cudaVersion} else null;

  # ── ISA restriction flags for SM61 (AVX-only) ──────────────────────
  isAVXOnly = isa == "avx";
  avxOnlyNegFlags = [ "-mno-fma" "-mno-bmi" "-mno-bmi2" "-mno-avx2" ];

  # ── Variant naming ──────────────────────────────────────────────────
  taVerShort = builtins.replaceStrings [ "." ] [ "" ] taVersion;
  pname =
    if isCuda   then "torchaudio${taVerShort}-python${pythonVersion}-cuda${cudaVersion}-sm${sm}-${isa}"
    else if isCpu  then "torchaudio${taVerShort}-python${pythonVersion}-cpu-${isa}"
    else "torchaudio${taVerShort}-python${pythonVersion}-darwin-mps";

  # ── Matching pytorch-nix wrapper name ──────────────────────────────
  ptVerShort = builtins.replaceStrings [ "." ] [ "" ]
    (builtins.head (builtins.match "([0-9]+\\.[0-9]+).*" taConfig.ptVersion));
  ptWrapperName =
    if isCuda   then "pytorch${ptVerShort}-python${pythonVersion}-cuda${cudaVersion}-sm${sm}-${isa}"
    else if isCpu  then "pytorch${ptVerShort}-python${pythonVersion}-cpu-${isa}"
    else "pytorch${ptVerShort}-python${pythonVersion}-darwin-mps";

  # ── Import matching pytorch-nix torch build ────────────────────────
  torchOverride = import "${toString pytorchNixRoot}/.flox/pkgs/${ptWrapperName}.nix" {};

  # ── Nixpkgs pin selection ──────────────────────────────────────────
  nixpkgsRev =
    if isCuda && taConfig ? cudaPinOverrides && taConfig.cudaPinOverrides ? ${cudaVersion}
    then taConfig.cudaPinOverrides.${cudaVersion}
    else if (isCpu || isMps) && taConfig ? cpuPin
    then taConfig.cpuPin
    else taConfig.nixpkgsPin;

  # ── Build fixups ───────────────────────────────────────────────────
  fixups = import ./build-fixups.nix {
    inherit taConfig torchOverride;
    cudaVersion = if isCuda then cudaVersion else null;
  };

  # ── Nixpkgs instantiation ─────────────────────────────────────────
  nixpkgs_pinned = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsRev}.tar.gz";
  }) ({
    config = {
      allowUnfree = true;
    }
    // (if isCuda then {
      cudaSupport = true;
    } else {})
    // fixups.extraConfig;
  } // (if isCuda then {
    overlays = [
      (final: prev: { cudaPackages = final.${cudaInfo.overlay}; })
    ] ++ fixups.extraOverlays;
  } else if fixups.extraOverlays != [] then {
    overlays = fixups.extraOverlays;
  } else {}));

  inherit (nixpkgs_pinned) lib;

  # ── GPU display info ───────────────────────────────────────────────
  gpuDisplayName = if isCuda then
    (if platform == "aarch64-linux" && smMeta ? aarch64GpuNames
     then smMeta.aarch64GpuNames else smMeta.gpuNames)
  else null;

  cudaDisplayVersion = if isCuda then
    builtins.replaceStrings [ "_" ] [ "." ] cudaVersion
  else null;

  # ── ISA display name ───────────────────────────────────────────────
  isaDisplayMap = {
    avx = "AVX"; avx2 = "AVX2"; avx512 = "AVX-512";
    avx512bf16 = "AVX-512 BF16"; avx512vnni = "AVX-512 VNNI";
    armv8_2 = "ARMv8.2"; armv9 = "ARMv9";
  };
  isaDisplay = if isa != null then isaDisplayMap.${isa} else null;

  # ── Description ────────────────────────────────────────────────────
  description =
    if isCuda then
      "TorchAudio ${taConfig.taVersion} (↔ PyTorch ${taConfig.ptVersion}) for NVIDIA ${gpuDisplayName} (SM${sm}) — ${isaDisplay} — CUDA ${cudaDisplayVersion} (driver ${cudaInfo.minDriver}+)"
    else if isMps then
      "TorchAudio ${taConfig.taVersion} (↔ PyTorch ${taConfig.ptVersion}) with MPS GPU acceleration for Apple Silicon"
    else
      "TorchAudio ${taConfig.taVersion} (↔ PyTorch ${taConfig.ptVersion}) CPU-only — ${isaDisplay}";

  # ── CPU flags ──────────────────────────────────────────────────────
  allCpuFlags =
    if isa == null then []
    else if isAVXOnly then isaConfig.flags ++ avxOnlyNegFlags
    else isaConfig.flags;

  # ── TORCH_CUDA_ARCH_LIST: torchaudio's RNN-T loss kernels honor this ─
  torchCudaArchList = if isCuda then smMeta.capability else "";

  # ── Build the package ──────────────────────────────────────────────
  baseTA = nixpkgs_pinned.${taConfig.pythonAttr}.torchaudio;

in
  # ── CUDA backend ───────────────────────────────────────────────────
  if isCuda then
    baseTA.overrideAttrs (oldAttrs: {
      inherit pname;
      passthru = (oldAttrs.passthru or {}) // {
        gpuArch = smMeta.capability;
        cpuISA = isa;
        torch = torchOverride;
      };

      ninjaFlags = [ "-j32" ];
      requiredSystemFeatures = [ "big-parallel" ];

      cmakeFlags = (oldAttrs.cmakeFlags or [])
        ++ fixups.extraCmakeFlags;

      preConfigure = (oldAttrs.preConfigure or "") + ''
        export CXXFLAGS="${lib.concatStringsSep " " allCpuFlags} $CXXFLAGS"
        export CFLAGS="${lib.concatStringsSep " " allCpuFlags} $CFLAGS"
        export TORCH_CUDA_ARCH_LIST="${torchCudaArchList}"
        export USE_CUDA=1
        export MAX_JOBS=32
      ''
      + fixups.extraPreConfigure
      + ''
        echo "GPU: SM${sm} (${gpuDisplayName}) | CPU: ${isaDisplay} | TorchAudio ${taConfig.taVersion} (↔ torch ${taConfig.ptVersion}) | CUDA ${cudaDisplayVersion}"
      '';

      meta = (oldAttrs.meta or {}) // {
        inherit description;
        platforms = [ platform ];
      };
    } // (lib.optionalAttrs fixups.clearPatches { patches = []; }))

  # ── CPU backend ────────────────────────────────────────────────────
  else if isCpu then
    baseTA.overrideAttrs (oldAttrs: {
      inherit pname;
      passthru = (oldAttrs.passthru or {}) // {
        gpuArch = null;
        cpuISA = isa;
        torch = torchOverride;
      };

      ninjaFlags = [ "-j32" ];
      requiredSystemFeatures = [ "big-parallel" ];

      buildInputs = lib.filter (p: !(lib.hasPrefix "cuda" (p.pname or "")))
        (oldAttrs.buildInputs or []);

      nativeBuildInputs = lib.filter (p: (p.pname or "") != "addDriverRunpath")
        (oldAttrs.nativeBuildInputs or []);

      cmakeFlags = (oldAttrs.cmakeFlags or [])
        ++ fixups.extraCmakeFlags
        ++ [ "-DUSE_CUDA=OFF" ];

      preConfigure = (oldAttrs.preConfigure or "") + ''
        export USE_CUDA=0
        export CXXFLAGS="${lib.concatStringsSep " " allCpuFlags} $CXXFLAGS"
        export CFLAGS="${lib.concatStringsSep " " allCpuFlags} $CFLAGS"
        export MAX_JOBS=32
      ''
      + fixups.extraPreConfigure
      + ''
        echo "CPU-only build | CPU: ${isaDisplay} | TorchAudio ${taConfig.taVersion} (↔ torch ${taConfig.ptVersion})"
      '';

      meta = (oldAttrs.meta or {}) // {
        inherit description;
        platforms = [ platform ];
      };
    } // (lib.optionalAttrs fixups.clearPatches { patches = []; }))

  # ── MPS (Darwin) backend ───────────────────────────────────────────
  else
    baseTA.overrideAttrs (oldAttrs: {
      inherit pname;
      passthru = (oldAttrs.passthru or {}) // {
        gpuArch = "mps";
        cpuISA = null;
        torch = torchOverride;
      };

      ninjaFlags = [ "-j32" ];
      requiredSystemFeatures = [ "big-parallel" ];

      buildInputs = lib.filter (p: !(lib.hasPrefix "cuda" (p.pname or "")))
        (oldAttrs.buildInputs or []);

      nativeBuildInputs = lib.filter (p: (p.pname or "") != "addDriverRunpath")
        (oldAttrs.nativeBuildInputs or []);

      cmakeFlags = (oldAttrs.cmakeFlags or [])
        ++ fixups.extraCmakeFlags
        ++ [ "-DUSE_CUDA=OFF" ];

      preConfigure = (oldAttrs.preConfigure or "") + ''
        export USE_CUDA=0
        export MAX_JOBS=32
      ''
      + fixups.extraPreConfigure
      + ''
        echo "MPS build | Platform: Apple Silicon | TorchAudio ${taConfig.taVersion} (↔ torch ${taConfig.ptVersion})"
      '';

      meta = (oldAttrs.meta or {}) // {
        inherit description;
        platforms = [ "aarch64-darwin" ];
      };
    } // (lib.optionalAttrs fixups.clearPatches { patches = []; }))

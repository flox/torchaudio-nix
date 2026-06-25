# TorchAudio Custom Build Environment

This Flox environment builds custom TorchAudio variants matched to specific [`pytorch-nix`](../pytorch-nix) variants for targeted optimizations. Every torchaudio variant links against the matching pytorch-nix torch build so the torch/torchaudio ABI stays consistent.

## Overview

TorchAudio ships a small set of CUDA kernels (RNN-T loss, etc.) plus FFI bindings for FFmpeg / soundfile. Like `pytorch-nix` and `torchvision-nix`, this repo builds **targeted variants** instead of upstream's everything-included wheels:

- **ABI-matched torch** — Each variant imports the matching `pytorch-nix` wrapper, eliminating torch/torchaudio skew.
- **Reproducible** — Pinned nixpkgs revisions, pinned upstream torchaudio tags via `sourceOverride`.

## Variant Coverage

| TorchAudio | Matching PyTorch | Python | CUDA | GPU Architectures | Variants |
|------------|------------------|--------|------|-------------------|----------|
| 2.10.0     | 2.10.0           | 3.13   | 12.8, 12.9, 13.0, 13.1 | SM61–SM121 | 265 |
| 2.11.0     | 2.11.0           | 3.13   | 12.8, 12.9, 13.0, 13.1 | SM61–SM121 | 265 |
| **Total**  |                  |        |                        |            | **530** |

SM61 (Pascal) is excluded from CUDA 13.0 and 13.1 variants — CUDA 13.0 nvcc removed `compute_61`. See the per-CUDA matrix docs for the explicit exclusions.

### No TorchAudio 2.12.x yet

Upstream `pytorch/audio` has not released a 2.12.x as of 2026-06-23. Latest is **2.11.0** (published 2026-03-23) — so the `2.12-313` slot intentionally stays empty until upstream ships. When it does, add a metadata entry and a row to `TA_COMBOS` in `scripts/generate-variants.sh`, then regenerate.

### Detailed Build Matrices

- **TorchAudio 2.10**: [CUDA 12.8](docs/matrices/torchaudio-2.10-cuda-12.8.md) · [CUDA 12.9](docs/matrices/torchaudio-2.10-cuda-12.9.md) · [CUDA 13.0](docs/matrices/torchaudio-2.10-cuda-13.0.md) · [CUDA 13.1](docs/matrices/torchaudio-2.10-cuda-13.1.md)
- **TorchAudio 2.11**: [CUDA 12.8](docs/matrices/torchaudio-2.11-cuda-12.8.md) · [CUDA 12.9](docs/matrices/torchaudio-2.11-cuda-12.9.md) · [CUDA 13.0](docs/matrices/torchaudio-2.11-cuda-13.0.md) · [CUDA 13.1](docs/matrices/torchaudio-2.11-cuda-13.1.md)

## Dependency on `pytorch-nix`

**Critical**: This repo is a sibling of `/home/daedalus/dev/builds/pytorch-nix` and must remain so. Each torchaudio wrapper imports the matching pytorch-nix wrapper at build time. The default `pytorchNixRoot` argument in `lib/mkTorchAudio.nix` resolves to `../../../../pytorch-nix`, i.e. the sibling directory.

Version pairing:

| TorchAudio | imports PyTorch wrapper |
|------------|-------------------------|
| 2.10.0     | `pytorch210-python313-cuda{cuda}-sm{sm}-{isa}` |
| 2.11.0     | `pytorch211-python313-cuda{cuda}-sm{sm}-{isa}` |

Build the matching pytorch-nix variant **first**, then the torchaudio variant.

## Quick Start

```bash
flox build torchaudio211-python313-cuda12_9-sm90-avx512
```

Each recipe is a standalone Nix expression, so plain Nix works too:

```bash
nix-build .flox/pkgs/torchaudio211-python313-cuda12_9-sm90-avx512.nix
```

## Naming Convention

```
torchaudio{taShort}-python{pyver}-{backend}-{isa}.nix
torchaudio{taShort}-python{pyver}-cuda{cudaver}-sm{sm}-{isa}.nix
torchaudio{taShort}-python{pyver}-darwin-mps.nix
```

- `{taShort}`: TorchAudio version without dots (`210`, `211`)
- `{pyver}`: Python minor version (`313`)
- `{cudaver}`: CUDA version with underscore (`12_8`, `12_9`, `13_0`, `13_1`)
- `{sm}`: SM architecture number
- `{isa}`: CPU ISA (`avx`, `avx2`, `avx512`, `avx512bf16`, `avx512vnni`, `armv8_2`, `armv9`)

## GPU Architecture Reference

| SM | Architecture | GPUs | Min Driver | CUDA Versions |
|----|-------------|------|------------|---------------|
| SM121 | Vera Rubin Ultra | R100 Ultra | 590+ | 13.0, 13.1 (aarch64-only) |
| SM120 | Vera Rubin | R100, RTX 5090 | 550+ | 12.8, 12.9, 13.0, 13.1 |
| SM110 | DRIVE Thor | DRIVE Thor | 580+ | 13.0, 13.1 (aarch64-only) |
| SM103 | Blackwell Ultra | B300, GB300 | 560+ | 12.9, 13.0, 13.1 |
| SM100 | Blackwell | B200, GB200 | 550+ | 12.8, 12.9, 13.0, 13.1 |
| SM90 | Hopper | H100, H200, L40S | 525+ | 12.8, 12.9, 13.0, 13.1 |
| SM89 | Ada Lovelace | L40, RTX 4090 | 520+ | 12.8, 12.9, 13.0, 13.1 |
| SM86 | Ampere | A40, RTX 3090 | 470+ | 12.8, 12.9, 13.0, 13.1 |
| SM80 | Ampere | A100, A30 | 450+ | 12.8, 12.9, 13.0, 13.1 |
| SM75 | Turing | T4, RTX 2080 Ti | 418+ | 12.8, 12.9, 13.0, 13.1 |
| SM70 | Volta | V100, Titan V | 390+ | 12.8, 12.9, 13.0, 13.1 |
| SM61 | Pascal | GTX 1070/1080/1080 Ti, P40 | 390+ | 12.8, 12.9 |

## CPU ISA Guide

| ISA | Hardware | Use Case |
|-----|----------|----------|
| `avx` | Sandy Bridge+ (2011+) | Maximum compatibility |
| `avx2` | Haswell+ (2013+) | Broad x86-64 compatibility |
| `avx512` | Skylake-X+ (2017+) | General FP32 workloads |
| `avx512bf16` | Cooper Lake+ (2020+) | BF16 mixed-precision training |
| `avx512vnni` | Skylake-SP+ (2017+) | INT8 quantized inference |
| `armv8_2` | Graviton2, older ARM | ARM servers without SVE2 |
| `armv9` | Grace, Graviton3+ | Modern ARM with SVE2 |

## Architecture

```
torchaudio-nix/
├── .flox/
│   ├── env/manifest.toml              # Build environment definition
│   └── pkgs/
│       ├── lib/
│       │   ├── cpu-isa.nix
│       │   ├── gpu-metadata.nix
│       │   ├── cuda-metadata.nix
│       │   ├── torchaudio-metadata.nix # (taVer, pyVer) → nixpkgs pin, ptVersion, source
│       │   ├── build-fixups.nix        # Source-override overlay
│       │   └── mkTorchAudio.nix        # Main parametric TorchAudio builder
│       └── torchaudio{210,211}-python313-*.nix  # 3-line wrapper files (generated)
├── scripts/
│   ├── generate-variants.sh
│   └── generate-matrices.sh
├── docs/matrices/
└── README.md
```

### How It Works

Each wrapper file is 3 lines — a comment, a function signature, and an import:

```nix
# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA H100, H200, L40S (SM90) — AVX-512 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "90"; isa = "avx512"; cudaVersion = "12_9"; }
```

The `mkTorchAudio.nix` parametric builder:
1. Looks up ISA config, GPU metadata, CUDA metadata, and TorchAudio metadata from the data tables.
2. Resolves the correct nixpkgs pin (may vary by CUDA version).
3. Imports the matching pytorch-nix wrapper as the substituted `torch`.
4. Instantiates nixpkgs with a Python-packages overlay that substitutes both `torch` (from pytorch-nix) and `torchaudio` (with the upstream `sourceOverride`).
5. Applies CUDA arch flags via `TORCH_CUDA_ARCH_LIST`.

### Regenerating Variants

After modifying metadata or adding a new TorchAudio version:

```bash
bash scripts/generate-variants.sh   # → Generated 530 variant files
bash scripts/generate-matrices.sh   # → Generated 8 matrix files
```

## Variant Selection Guide

Mirrors pytorch-nix:
- H100 datacenter (x86) → `sm90-avx512`
- RTX 5090 workstation → `sm120-avx512` or `sm120-avx2`
- AWS Graviton3 + H100 → `sm90-armv9`
- Apple Silicon → `darwin-mps`
- CPU inference (datacenter) → `cpu-avx512` or `cpu-avx512vnni`
- CPU inference (broad compat) → `cpu-avx2`

## Publishing

```bash
flox publish -o <your-org> torchaudio211-python313-cuda12_9-sm90-avx512
flox install <your-org>/torchaudio211-python313-cuda12_9-sm90-avx512
```

## License

Build environment configuration is MIT licensed. TorchAudio itself is BSD-2-Clause licensed.

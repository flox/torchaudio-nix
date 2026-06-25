# TorchAudio 2.11 + CUDA 13.0 — Build Matrix

- **TorchAudio**: 2.11.0
- **PyTorch** (matching torch ABI): 2.11.0 — provided by sibling repo `pytorch-nix`
- **CUDA**: 13.0
- **Min driver**: 580+
- **Python versions**: 3.13

Package names follow `torchaudio211-python313-cuda13_0-sm{sm}-{isa}`.

## GPU Variants

### SM70 — Volta (V100, Titan V)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| AVX | `...-sm70-avx` | V100, Titan V + legacy x86 CPUs |
| AVX2 | `...-sm70-avx2` | V100, Titan V + broad x86 compatibility |
| AVX-512 | `...-sm70-avx512` | V100, Titan V + general datacenter |
| AVX-512 BF16 | `...-sm70-avx512bf16` | V100, Titan V + BF16 mixed-precision |
| AVX-512 VNNI | `...-sm70-avx512vnni` | V100, Titan V + INT8 quantized inference |
| ARMv8.2 | `...-sm70-armv8_2` | V100, Titan V + Graviton2 |
| ARMv9 | `...-sm70-armv9` | V100, Titan V + Grace/Graviton3+ |

### SM75 — Turing (T4, RTX 2080 Ti)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| AVX | `...-sm75-avx` | T4, RTX 2080 Ti + legacy x86 CPUs |
| AVX2 | `...-sm75-avx2` | T4, RTX 2080 Ti + broad x86 compatibility |
| AVX-512 | `...-sm75-avx512` | T4, RTX 2080 Ti + general datacenter |
| AVX-512 BF16 | `...-sm75-avx512bf16` | T4, RTX 2080 Ti + BF16 mixed-precision |
| AVX-512 VNNI | `...-sm75-avx512vnni` | T4, RTX 2080 Ti + INT8 quantized inference |
| ARMv8.2 | `...-sm75-armv8_2` | T4, RTX 2080 Ti + Graviton2 |
| ARMv9 | `...-sm75-armv9` | T4, RTX 2080 Ti + Grace/Graviton3+ |

### SM80 — Ampere (A100, A30)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| AVX | `...-sm80-avx` | A100, A30 + legacy x86 CPUs |
| AVX2 | `...-sm80-avx2` | A100, A30 + broad x86 compatibility |
| AVX-512 | `...-sm80-avx512` | A100, A30 + general datacenter |
| AVX-512 BF16 | `...-sm80-avx512bf16` | A100, A30 + BF16 mixed-precision |
| AVX-512 VNNI | `...-sm80-avx512vnni` | A100, A30 + INT8 quantized inference |
| ARMv8.2 | `...-sm80-armv8_2` | A100 (ARM) + Graviton2 |
| ARMv9 | `...-sm80-armv9` | A100 (ARM) + Grace/Graviton3+ |

### SM86 — Ampere (A40, RTX 3090)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| AVX | `...-sm86-avx` | A40, RTX 3090 + legacy x86 CPUs |
| AVX2 | `...-sm86-avx2` | A40, RTX 3090 + broad x86 compatibility |
| AVX-512 | `...-sm86-avx512` | A40, RTX 3090 + general datacenter |
| AVX-512 BF16 | `...-sm86-avx512bf16` | A40, RTX 3090 + BF16 mixed-precision |
| AVX-512 VNNI | `...-sm86-avx512vnni` | A40, RTX 3090 + INT8 quantized inference |
| ARMv8.2 | `...-sm86-armv8_2` | A40, RTX 3090 + Graviton2 |
| ARMv9 | `...-sm86-armv9` | A40, RTX 3090 + Grace/Graviton3+ |

### SM89 — Ada Lovelace (L40, RTX 4090)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| AVX | `...-sm89-avx` | L40, RTX 4090 + legacy x86 CPUs |
| AVX2 | `...-sm89-avx2` | L40, RTX 4090 + broad x86 compatibility |
| AVX-512 | `...-sm89-avx512` | L40, RTX 4090 + general datacenter |
| AVX-512 BF16 | `...-sm89-avx512bf16` | L40, RTX 4090 + BF16 mixed-precision |
| AVX-512 VNNI | `...-sm89-avx512vnni` | L40, RTX 4090 + INT8 quantized inference |
| ARMv8.2 | `...-sm89-armv8_2` | L40, RTX 4090 + Graviton2 |
| ARMv9 | `...-sm89-armv9` | L40, RTX 4090 + Grace/Graviton3+ |

### SM90 — Hopper (H100, H200, L40S)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| AVX | `...-sm90-avx` | H100, H200, L40S + legacy x86 CPUs |
| AVX2 | `...-sm90-avx2` | H100, H200, L40S + broad x86 compatibility |
| AVX-512 | `...-sm90-avx512` | H100, H200, L40S + general datacenter |
| AVX-512 BF16 | `...-sm90-avx512bf16` | H100, H200, L40S + BF16 mixed-precision |
| AVX-512 VNNI | `...-sm90-avx512vnni` | H100, H200, L40S + INT8 quantized inference |
| ARMv8.2 | `...-sm90-armv8_2` | GH200 + Graviton2 |
| ARMv9 | `...-sm90-armv9` | GH200 + Grace/Graviton3+ |

### SM100 — Blackwell (B200, GB200)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| AVX | `...-sm100-avx` | B200, GB200 + legacy x86 CPUs |
| AVX2 | `...-sm100-avx2` | B200, GB200 + broad x86 compatibility |
| AVX-512 | `...-sm100-avx512` | B200, GB200 + general datacenter |
| AVX-512 BF16 | `...-sm100-avx512bf16` | B200, GB200 + BF16 mixed-precision |
| AVX-512 VNNI | `...-sm100-avx512vnni` | B200, GB200 + INT8 quantized inference |
| ARMv8.2 | `...-sm100-armv8_2` | GB200 + Graviton2 |
| ARMv9 | `...-sm100-armv9` | GB200 + Grace/Graviton3+ |

### SM103 — Blackwell Ultra (B300, GB300)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| AVX | `...-sm103-avx` | B300, GB300 + legacy x86 CPUs |
| AVX2 | `...-sm103-avx2` | B300, GB300 + broad x86 compatibility |
| AVX-512 | `...-sm103-avx512` | B300, GB300 + general datacenter |
| AVX-512 BF16 | `...-sm103-avx512bf16` | B300, GB300 + BF16 mixed-precision |
| AVX-512 VNNI | `...-sm103-avx512vnni` | B300, GB300 + INT8 quantized inference |
| ARMv8.2 | `...-sm103-armv8_2` | GB300 + Graviton2 |
| ARMv9 | `...-sm103-armv9` | GB300 + Grace/Graviton3+ |

### SM110 — DRIVE Thor (aarch64-only)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| ARMv8.2 | `...-sm110-armv8_2` | DRIVE Thor + older ARM |
| ARMv9 | `...-sm110-armv9` | DRIVE Thor + modern ARM |

### SM120 — Vera Rubin (R100, RTX 5090)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| AVX | `...-sm120-avx` | R100, RTX 5090 + legacy x86 CPUs |
| AVX2 | `...-sm120-avx2` | R100, RTX 5090 + broad x86 compatibility |
| AVX-512 | `...-sm120-avx512` | R100, RTX 5090 + general datacenter |
| AVX-512 BF16 | `...-sm120-avx512bf16` | R100, RTX 5090 + BF16 mixed-precision |
| AVX-512 VNNI | `...-sm120-avx512vnni` | R100, RTX 5090 + INT8 quantized inference |
| ARMv8.2 | `...-sm120-armv8_2` | R100, RTX 5090 + Graviton2 |
| ARMv9 | `...-sm120-armv9` | R100, RTX 5090 + Grace/Graviton3+ |

### SM121 — Vera Rubin Ultra (aarch64-only)

| ISA | Package Name | Use Case |
|-----|-------------|----------|
| ARMv8.2 | `...-sm121-armv8_2` | R100 Ultra + older ARM |
| ARMv9 | `...-sm121-armv9` | R100 Ultra + modern ARM |

*Not available at CUDA 13.0: SM61 (capped at CUDA 12.9)*

# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA B300, GB300 (SM103) — AVX-512 BF16 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "103"; isa = "avx512bf16"; cudaVersion = "12_9"; }

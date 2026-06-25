# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA T4, RTX 2080 Ti (SM75) — AVX-512 BF16 — CUDA 12.8 (driver 550+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "75"; isa = "avx512bf16"; cudaVersion = "12_8"; }

# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA B200, GB200 (SM100) — AVX-512 BF16 — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "100"; isa = "avx512bf16"; cudaVersion = "13_0"; }

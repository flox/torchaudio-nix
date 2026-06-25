# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA A40, RTX 3090 (SM86) — AVX-512 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "86"; isa = "avx512"; cudaVersion = "12_9"; }

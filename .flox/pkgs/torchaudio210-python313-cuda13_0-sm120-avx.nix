# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA R100, RTX 5090 (SM120) — AVX — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "120"; isa = "avx"; cudaVersion = "13_0"; }

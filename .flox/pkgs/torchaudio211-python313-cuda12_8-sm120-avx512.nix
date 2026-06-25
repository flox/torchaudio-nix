# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA R100, RTX 5090 (SM120) — AVX-512 — CUDA 12.8 (driver 550+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "120"; isa = "avx512"; cudaVersion = "12_8"; }

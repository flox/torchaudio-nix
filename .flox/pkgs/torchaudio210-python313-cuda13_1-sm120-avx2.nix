# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA R100, RTX 5090 (SM120) — AVX2 — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "120"; isa = "avx2"; cudaVersion = "13_1"; }

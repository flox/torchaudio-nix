# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA R100, RTX 5090 (SM120) — AVX-512 VNNI — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "120"; isa = "avx512vnni"; cudaVersion = "12_9"; }

# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA L40, RTX 4090 (SM89) — AVX-512 VNNI — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "89"; isa = "avx512vnni"; cudaVersion = "12_9"; }

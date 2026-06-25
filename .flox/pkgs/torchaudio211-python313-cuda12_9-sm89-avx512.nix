# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA L40, RTX 4090 (SM89) — AVX-512 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "89"; isa = "avx512"; cudaVersion = "12_9"; }

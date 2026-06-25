# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA B300, GB300 (SM103) — AVX-512 VNNI — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "103"; isa = "avx512vnni"; cudaVersion = "13_0"; }

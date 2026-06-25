# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA B300, GB300 (SM103) — AVX — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "103"; isa = "avx"; cudaVersion = "13_1"; }
